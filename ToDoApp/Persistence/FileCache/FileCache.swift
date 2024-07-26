//
//  FileCache.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/27/24.
//

import Foundation
import SwiftData
import SQLite3

class FileCache {
    private let fileManager = FileManager.default
    
    private var modelContainer: ModelContainer?
    private var modelContext: ModelContext?
    
    private var db: OpaquePointer?
    
    private var dataStorage: DataStorage
    
    public init(_ dataStorage: DataStorage = .swiftData) {
        self.dataStorage = dataStorage
        switch dataStorage {
        case .swiftData:
            do {
                self.modelContainer = try ModelContainer(for: TodoItemDb.self)
                if let modelContainer {
                    self.modelContext = ModelContext(modelContainer)
                }
            } catch {
                fatalError(error.localizedDescription)
            }
        case .sqlite:
            self.db = self.openDatabase()
        }
    }
    
    deinit {
        self.closeDatabase()
    }
    
    func insert(_ todoItem: TodoItemDb) {
        switch dataStorage {
            case .swiftData:
                insertSwiftData(todoItem)
            case .sqlite:
                insertDb(todoItem, into: db)
        }
    }
    
    func fetch() -> [TodoItemDb] {
        switch dataStorage {
            case .swiftData:
                return fetchSwiftData()
            case .sqlite:
                return fetchDb(db: db)
        }
    }
    
    func update(_ todoItem: TodoItemDb) {
        switch dataStorage {
            case .swiftData:
                updateSwiftData(todoItem)
            case .sqlite:
                updateDb(todoItem, in: db)
        }
    }
    
    func delete(_ todoItem: TodoItemDb) {
        switch dataStorage {
            case .swiftData:
                deleteSwiftData(todoItem)
            case .sqlite:
                deleteDb(withId: todoItem.id.uuidString, from: db)
        }
    }
}

extension FileCache {
    private func insertSwiftData(_ todoItem: TodoItemDb) {
        modelContext?.insert(todoItem)
    }
    
    private func fetchSwiftData() -> [TodoItemDb] {
        do {
            return try modelContext?.fetch(FetchDescriptor<TodoItemDb>()) ?? []
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func fetchWithSort<TField: Comparable>(sortBy keyPath: KeyPath<TodoItemDb, TField>, order: SortOrder = .forward) -> [TodoItemDb] {
        let fetchDescriptor = FetchDescriptor(sortBy: [SortDescriptor(keyPath, order: order)])
        do {
            return try modelContext?.fetch(fetchDescriptor) ?? []
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    private func deleteSwiftData(_ todoItem: TodoItemDb) {
        modelContext?.delete(todoItem)
    }
    
    private func updateSwiftData(_ todoItem: TodoItemDb) {
        let item = getByIdSwiftData(todoItem.id)
        guard let item = item else { return }
        deleteSwiftData(item)
        insertSwiftData(todoItem)
    }
    
    func getByIdSwiftData(_ id: UUID) -> TodoItemDb? {
        let predicate = #Predicate<TodoItemDb> { $0.id == id }
        var fetchDescriptor = FetchDescriptor(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        do {
            let items = try modelContext?.fetch(fetchDescriptor) ?? []
            if items.count == 0 {
                return nil
            }
            return items[0]
        } catch {
            return nil
        }
    }
}

extension FileCache {
    private func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer?
        let fileURL = try? fileManager
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("todos.sqlite")
        
        if !fileManager.fileExists(atPath: fileURL?.path() ?? "") {
            if sqlite3_open(fileURL?.path(), &db) == SQLITE_OK {
                print("Successfully opened connection to database at \(fileURL?.path() ?? "")")
                if createTables(db: db) {
                    print("Tables created successfully")
                } else {
                    print("Failed to create tables")
                }
            } else {
                print("Error opening database")
                return nil
            }
        } else {
            if sqlite3_open(fileURL?.path(), &db) != SQLITE_OK {
                print("Error opening database")
                return nil
            } else {
                print("Successfully opened connection to database at: \(fileURL?.path() ?? "")")
            }
        }
        
        return db
    }
    
    private func closeDatabase() {
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        } else {
            print("Successfully closed database")
        }
        db = nil
    }
}

extension FileCache {
    private func fetchDb(db: OpaquePointer?) -> [TodoItemDb] {
        let querySql = "SELECT * FROM TodoItem"
        var statement: OpaquePointer? = nil
        
        guard sqlite3_prepare_v2(db, querySql, -1, &statement, nil) == SQLITE_OK else {
            print("Failed to prepare statement. Error: \(String(cString: sqlite3_errmsg(db)))")
            return []
        }
        
        defer {
            sqlite3_finalize(statement)
        }
        
        var todoItems: [TodoItemDb] = []
        
        while sqlite3_step(statement) == SQLITE_ROW {
            guard let id = sqlite3_column_text(statement, 0).flatMap({ UUID(uuidString: String(cString: $0)) }),
                  let text = sqlite3_column_text(statement, 1).flatMap({ String(cString: $0) }),
                  let importanceId = sqlite3_column_text(statement, 2).flatMap({ String(cString: $0) }) else {
                continue
            }
            
            let expires = sqlite3_column_int64(statement, 3) != 0 ? sqlite3_column_int64(statement, 3).toDate() : nil
            let isCompleted = sqlite3_column_int(statement, 4) != 0
            let createdDate = sqlite3_column_int64(statement, 5).toDate()
            let changedDate = sqlite3_column_int64(statement, 6) != 0 ? sqlite3_column_int64(statement, 6).toDate() : nil
            let color = sqlite3_column_text(statement, 7).flatMap({ String(cString: $0) })
            
            let importance = Importance(rawValue: importanceId) ?? .basic
            
            let todoItem = TodoItemDb(
                id: id,
                text: text,
                importance: importance,
                expires: expires,
                isCompleted: isCompleted,
                createdDate: createdDate,
                changedDate: changedDate,
                color: color
            )
            
            todoItems.append(todoItem)
        }
        
        return todoItems
    }
    
    private func insertDb(_ item: TodoItemDb, into db: OpaquePointer?) {
        let insertSql = """
        INSERT INTO TodoItem (id, text, importanceId, expires, isCompleted, createdDate, changedDate, color)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """
        var statement: OpaquePointer? = nil
        
        guard sqlite3_prepare_v2(db, insertSql, -1, &statement, nil) == SQLITE_OK else {
            print("Failed to prepare statement. Error: \(String(cString: sqlite3_errmsg(db)))")
            return
        }
        
        defer {
            sqlite3_finalize(statement)
        }
        
        sqlite3_bind_text(statement, 1, item.id.uuidString, -1, nil)
        sqlite3_bind_text(statement, 2, item.text, -1, nil)
        sqlite3_bind_text(statement, 3, item.importance.rawValue, -1, nil)
        if let expires = item.expires {
            sqlite3_bind_int64(statement, 4, expires.toUnixTimestamp())
        } else {
            sqlite3_bind_null(statement, 4)
        }
        sqlite3_bind_int(statement, 5, item.isCompleted ? 1 : 0)
        sqlite3_bind_int64(statement, 6, item.createdDate.toUnixTimestamp())
        if let changedDate = item.changedDate {
            sqlite3_bind_int64(statement, 7, changedDate.toUnixTimestamp())
        } else {
            sqlite3_bind_null(statement, 7)
        }
        if let color = item.color {
            sqlite3_bind_text(statement, 8, color, -1, nil)
        } else {
            sqlite3_bind_null(statement, 8)
        }
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            print("Failed to insert item. Error: \(String(cString: sqlite3_errmsg(db)))")
            return
        }
    }

    private func updateDb(_ item: TodoItemDb, in db: OpaquePointer?) {
        let updateSql = """
        UPDATE TodoItem
        SET text = ?, importanceId = ?, expires = ?, isCompleted = ?, createdDate = ?, changedDate = ?, color = ?
        WHERE id = ?
        """
        var statement: OpaquePointer? = nil
        
        guard sqlite3_prepare_v2(db, updateSql, -1, &statement, nil) == SQLITE_OK else {
            print("Failed to prepare statement. Error: \(String(cString: sqlite3_errmsg(db)))")
            return
        }
        
        defer {
            sqlite3_finalize(statement)
        }
        
        sqlite3_bind_text(statement, 1, item.text, -1, nil)
        sqlite3_bind_text(statement, 2, item.importance.rawValue, -1, nil)
        if let expires = item.expires {
            sqlite3_bind_int64(statement, 3, expires.toUnixTimestamp())
        } else {
            sqlite3_bind_null(statement, 3)
        }
        sqlite3_bind_int(statement, 4, item.isCompleted ? 1 : 0)
        sqlite3_bind_int64(statement, 5, item.createdDate.toUnixTimestamp())
        if let changedDate = item.changedDate {
            sqlite3_bind_int64(statement, 6, changedDate.toUnixTimestamp())
        } else {
            sqlite3_bind_null(statement, 6)
        }
        if let color = item.color {
            sqlite3_bind_text(statement, 7, color, -1, nil)
        } else {
            sqlite3_bind_null(statement, 7)
        }
        sqlite3_bind_text(statement, 8, item.id.uuidString, -1, nil)
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            print("Failed to update item. Error: \(String(cString: sqlite3_errmsg(db)))")
            return
        }
    }

    private func deleteDb(withId id: String, from db: OpaquePointer?) {
        let deleteSql = "DELETE FROM TodoItem WHERE id = ?"
        var statement: OpaquePointer? = nil
        
        guard sqlite3_prepare_v2(db, deleteSql, -1, &statement, nil) == SQLITE_OK else {
            print("Failed to prepare statement. Error: \(String(cString: sqlite3_errmsg(db)))")
            return
        }
        
        defer {
            sqlite3_finalize(statement)
        }
        
        sqlite3_bind_text(statement, 1, id, -1, nil)
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            print("Failed to delete item. Error: \(String(cString: sqlite3_errmsg(db)))")
            return
        }
    }

}

extension FileCache {
    private func createTables(db: OpaquePointer?) -> Bool {
        guard createImportanceTable(db: db) else {
            print("Failed to create Importance table")
            return false
        }
        
        guard createTodoItemTable(db: db) else {
            print("Failed to create TodoItem table")
            return false
        }
        
        return true
    }
    
    private func createImportanceTable(db: OpaquePointer?) -> Bool {
        let createTableSql = """
        CREATE TABLE Importance (
            importanceId TEXT PRIMARY KEY
        );
        """
        guard self.prepare(sqlString: createTableSql, db, operation: "CREATE TABLE Importance") else {
            print("Failed to create Importance table")
            return false
        }
        
        let insertSql = """
        INSERT INTO Importance VALUES ('low'), ('basic'), ('important');
        """
        guard self.prepare(sqlString: insertSql, db, operation: "INSERT INTO Importance") else {
            print("Failed to insert values into Importance")
            return false
        }
        
        return true
    }
    
    private func createTodoItemTable(db: OpaquePointer?) -> Bool {
        let createTableSql = """
        CREATE TABLE TodoItem (
            id TEXT PRIMARY KEY,
            text TEXT NOT NULL,
            importanceId TEXT NOT NULL,
            expires INTEGER,
            isCompleted BOOL NOT NULL,
            createdDate INTEGER NOT NULL,
            changedDate INTEGER,
            color TEXT,
            FOREIGN KEY (importanceId) REFERENCES Importance(importanceId)
        );
        """
        
        guard self.prepare(sqlString: createTableSql, db, operation: "CREATE TABLE TodoItem") else {
            print("Failed to create TodoItem table")
            return false
        }
        
        return true
    }
}

extension FileCache {
    private func prepare(sqlString: String, _ db: OpaquePointer?, operation: String = "") -> Bool {
        var statement: OpaquePointer? = nil
        defer {
            sqlite3_finalize(statement)
        }
        
        guard sqlite3_prepare_v2(db, sqlString, -1, &statement, nil) == SQLITE_OK else {
            print("Failed to prepare stetement for operation: \(operation). Error: \(String(cString: sqlite3_errmsg(db)))")
            return false
        }
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            print("Failed to execute statement for operation: \(operation). Error: \(String(cString: sqlite3_errmsg(db)))")
            return false
        }
        
        print("Successfully executed stetment for operation: \(operation)")
        return true
    }
}
