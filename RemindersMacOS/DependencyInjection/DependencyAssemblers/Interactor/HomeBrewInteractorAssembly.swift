//
//  HomeBrewInteractorAssembly.swift
//  RemindersMacOS
//
//  Created by Thomas on 15.11.23.
//

import Foundation
import Swinject
import Reminders_Domain
import Reminders_Brew

final class HomeBrewInteractorAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(HomeBrewMainInteractorProtocol.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return HomeBrewMainInteractor(
                getHomeBrewFormulaeUseCase: useCaseProvider.getHomeBrewFormulaeUC(),
                getHomeBrewCasksUseCase: useCaseProvider.getHomeBrewCasksUC(),
                unInstallPackageUseCase: useCaseProvider.uninstallPackageUC(),
                getHomeBrewTapsUseCase: useCaseProvider.getHomeBrewTapsUC(),
                unInstallTapUseCase: useCaseProvider.uninstallTapUC(),
                getOutdatedPackagesUseCase: useCaseProvider.getOutdatedPackagesUC()
            )
        }
        container.register(TapDetailInteractorProtocol.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return TapDetailInteractor(
                getBrewTapInfoUseCase: useCaseProvider.getBrewTapInfoUC()
            )
        }
        container.register(PackageDetailInteractorProtocol.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return PackageDetailInteractor(
                getBrewPackageInfoUseCase: useCaseProvider.getBrewPackageInfoUC(),
                pinAndUnpinPackageUseCase: useCaseProvider.pinAndUnpinPackageUC()
            )
        }
    }
}


