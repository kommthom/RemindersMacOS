//
//  MyListsInteractorAssembly.swift
//  RemindersMacOS
//
//  Created by Thomas on 15.11.23.
//

import Foundation
import Swinject
import Reminders_Domain
import Reminders_MyLists

final class MyListsInteractorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MyListsInteractorProtocol.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return DefaultMyListsInteractor(
                getMyListsUseCase: useCaseProvider.getMyListsUC(),
                updateMyListUseCase: useCaseProvider.updateMyListUC(),
                deleteMyListUseCase: useCaseProvider.deleteMyListUC()
            )
        }
        container.register(MyListItemsInteractorProtocol.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return DefaultMyListItemsInteractor(
                deleteMyListItemUseCase: useCaseProvider.deleteMyListItemUC(),
                updateMyListItemUseCase: useCaseProvider.updateMyListItemUC(),
                createMyListItemUseCase: useCaseProvider.createMyListItemUC()
            )
        }
    }
}
