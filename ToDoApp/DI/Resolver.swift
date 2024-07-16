//
//  Resolver.swift
//  ToDoApp
//
//  Created by Иван Спирин on 7/16/24.
//

import Foundation

@propertyWrapper
struct Inject<Component> {
    let wrappedValue: Component
    init() {
        self.wrappedValue = Resolver.shared.resolve(Component.self)
    }
}

final class Resolver {
    static let shared = Resolver()
    private let container = buildContainer()
    
    func resolve<T>(_ type: T.Type) -> T {
        container.resolve(T.self)!
    }
}

func buildContainer() -> Container {
    let container = Container()
    
    container.register(NetworkProtocol.self) {
        NetworkService()
    }
    
    return container
}
