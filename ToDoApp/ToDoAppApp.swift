//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Иван Спирин on 6/17/24.
//

import SwiftUI
import CocoaLumberjack

@main
struct ToDoAppApp: App {
    
    init() {
        DDLog.add(DDOSLogger.sharedInstance)
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
