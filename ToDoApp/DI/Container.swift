//
//  Container.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/16/24.
//

import Foundation

final class Container {
    private var services: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        self.services[key] = factory
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        if let factory = self.services[key] as? () -> T {
            return factory()
        }
        
        return nil
    }
}
