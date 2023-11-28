//
//  DIContainer.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.11.23.
//

import Swinject

final class DIContainer {

    static let shared = DIContainer()

    let container: Container = Container()
    let assembler: Assembler
    var isMockContainer: Bool = false

    init() {
        if isMockContainer {
            assembler = Assembler(
                [
                    MockedUseCaseAssembly(),
                    ProviderAssembly(),
                    InteractorAssembly(),
                    ViewModelAssembly()
                ],
                container: container)
        } else {
            assembler = Assembler(
                [
                    DataSourceAssembly(),
                    RepositoryAssembly(),
                    UseCaseAssembly(),
                    ProviderAssembly(),
                    InteractorAssembly(),
                    ViewModelAssembly()
                ],
                container: container)
        }
    }

    func buildMockContainer() -> DIContainer {
        isMockContainer = true
        return self
    }
    
    func resolve<T>() -> T {
        guard let resolvedType = container.resolve(T.self) else {
            fatalError()
        }
        return resolvedType
    }

    func resolve<T>(registrationName: String?) -> T {
        guard let resolvedType = container.resolve(T.self, name: registrationName) else {
            fatalError()
        }
        return resolvedType
    }

    func resolve<T, Arg>(argument: Arg) -> T {
        guard let resolvedType = container.resolve(T.self, argument: argument) else {
            fatalError()
        }
        return resolvedType
    }

    func resolve<T, Arg1, Arg2>(arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let resolvedType = container.resolve(T.self, arguments: arg1, arg2) else {
            fatalError()
        }
        return resolvedType
    }

    func resolve<T, Arg>(name: String?, argument: Arg) -> T {
        guard let resolvedType = container.resolve(T.self, name: name, argument: argument) else {
            fatalError()
        }
        return resolvedType
    }

    func resolve<T, Arg1, Arg2>(name: String?, arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let resolvedType = container.resolve(T.self, name: name, arguments: arg1, arg2) else {
            fatalError()
        }
        return resolvedType
    }

}

