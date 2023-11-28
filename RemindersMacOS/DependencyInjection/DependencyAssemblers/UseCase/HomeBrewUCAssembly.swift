//
//  HomeBrewUCAssembly.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.11.23.
//


import Swinject
import Reminders_Domain
import Reminders_Brew

final class HomeBrewUCAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetHomeBrewFormulaeUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("GetHomeBrewFormulaeUCProtocol dependency could not be resolved")
            }
            return DefaultGetHomeBrewFormulaeUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(GetHomeBrewCasksUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("GetHomeBrewCasksUCProtocol dependency could not be resolved")
            }
            return DefaultGetHomeBrewCasksUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(GetHomeBrewTapsUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("GetHomeBrewTapsUCProtocol dependency could not be resolved")
            }
            return DefaultGetHomeBrewTapsUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(UninstallTapUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("UninstallTapUCProtocol dependency could not be resolved")
            }
            return DefaultUninstallTapUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(UninstallPackageUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("UninstallPackageUC dependency could not be resolved")
            }
            return DefaultUninstallPackageUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(PinAndUnpinPackageUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("PinAndUnpinPackageUC dependency could not be resolved")
            }
            return DefaultPinAndUnpinPackageUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(GetBrewPackageInfoUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("GetBrewPackageInfoUC dependency could not be resolved")
            }
            return DefaultGetBrewPackageInfoUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(GetBrewTapInfoUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("GetBrewTapInfoUC dependency could not be resolved")
            }
            return DefaultGetBrewTapInfoUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(GetOutdatedPackagesUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("GetOutdatedPackagesUC dependency could not be resolved")
            }
            return DefaultGetOutdatedPackagesUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(RemoveOrphansUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("RemoveOrphansUC dependency could not be resolved")
            }
            return DefaultRemoveOrphansUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(PurgeHomebrewCacheUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("PurgeHomebrewCacheUC dependency could not be resolved")
            }
            return DefaultPurgeHomebrewCacheUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(DeleteCachedDownloadsUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("DeleteCachedDownloadsUC dependency could not be resolved")
            }
            return DefaultDeleteCachedDownloadsUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(PerformBrewHealthCheckUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("PerformBrewHealthCheckUC dependency could not be resolved")
            }
            return DefaultPerformBrewHealthCheckUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(GetTopFormulaeUCProtocol.self) { resolver in
            guard let homeBrewWebRepository = resolver.resolve(HomeBrewWebRepositoryProtocol.self) else {
                fatalError("GetTopFormulaeUC dependency could not be resolved")
            }
            return DefaultGetTopFormulaeUC(homeBrewWebRepository: homeBrewWebRepository)
        }.inObjectScope(.container)
        container.register(GetTopCasksUCProtocol.self) { resolver in
            guard let homeBrewWebRepository = resolver.resolve(HomeBrewWebRepositoryProtocol.self) else {
                fatalError("GetTopCasksUC dependency could not be resolved")
            }
            return DefaultGetTopCasksUC(homeBrewWebRepository: homeBrewWebRepository)
        }.inObjectScope(.container)
        container.register(GetBrewPackageDescriptionUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("GetBrewPackageDescriptionUC dependency could not be resolved")
            }
            return DefaultGetBrewPackageDescriptionUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(GetSearchedPackagesUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("GetSearchedPackagesUC dependency could not be resolved")
            }
            return DefaultGetSearchedPackagesUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(UpdateOnePackageUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("UpdateOnePackageUC dependency could not be resolved")
            }
            return DefaultUpdateOnePackageUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(AreUpdatablePackagesAvailableUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("AreUpdatablePackagesAvailableUC dependency could not be resolved")
            }
            return DefaultAreUpdatablePackagesAvailableUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(UpdatePackagesUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("UpdatePackagesUC dependency could not be resolved")
            }
            return DefaultUpdatePackagesUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
        container.register(UpdateOutdatedPackagesTrackerUCProtocol.self) { resolver in
            guard let homeBrewShellRepository = resolver.resolve(HomeBrewShellRepositoryProtocol.self) else {
                fatalError("UpdateOutdatedPackagesTrackerUCProtocol dependency could not be resolved")
            }
            return DefaultUpdateOutdatedPackagesTrackerUC(homeBrewShellRepository: homeBrewShellRepository)
        }.inObjectScope(.container)
    }
}

final class MockedHomeBrewUCAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetHomeBrewFormulaeUCProtocol.self) { resolver in
            return MockedGetHomeBrewFormulaeUC()
        }.inObjectScope(.container)
        container.register(GetHomeBrewCasksUCProtocol.self) { resolver in
            return MockedGetHomeBrewCasksUC()
        }.inObjectScope(.container)
        container.register(GetHomeBrewTapsUCProtocol.self) { resolver in
            return MockedGetHomeBrewTapsUC()
        }.inObjectScope(.container)
        container.register(UninstallTapUCProtocol.self) { resolver in
            return MockedUninstallTapUC()
        }.inObjectScope(.container)
        container.register(UninstallPackageUCProtocol.self) { resolver in
            return MockedUninstallPackageUC()
        }.inObjectScope(.container)
        container.register(PinAndUnpinPackageUCProtocol.self) { resolver in
            return MockedPinAndUnpinPackageUC()
        }.inObjectScope(.container)
        container.register(GetBrewPackageInfoUCProtocol.self) { resolver in
            return MockedGetBrewPackageInfoUC()
        }.inObjectScope(.container)
        container.register(GetBrewTapInfoUCProtocol.self) { resolver in
            return MockedGetBrewTapInfoUC()
        }.inObjectScope(.container)
        container.register(GetOutdatedPackagesUCProtocol.self) { resolver in
            return MockedGetOutdatedPackagesUC()
        }.inObjectScope(.container)
        container.register(RemoveOrphansUCProtocol.self) { resolver in
            return MockedRemoveOrphansUC()
        }.inObjectScope(.container)
        container.register(PurgeHomebrewCacheUCProtocol.self) { resolver in
            return MockedPurgeHomebrewCacheUC()
        }.inObjectScope(.container)
        container.register(DeleteCachedDownloadsUCProtocol.self) { resolver in
            return MockedDeleteCachedDownloadsUC()
        }.inObjectScope(.container)
        container.register(PerformBrewHealthCheckUCProtocol.self) { resolver in
            return MockedPerformBrewHealthCheckUC()
        }.inObjectScope(.container)
        container.register(GetTopFormulaeUCProtocol.self) { resolver in
            return MockedGetTopFormulaeUC()
        }.inObjectScope(.container)
        container.register(GetTopCasksUCProtocol.self) { resolver in
            return MockedGetTopCasksUC()
        }.inObjectScope(.container)
        container.register(GetBrewPackageDescriptionUCProtocol.self) { resolver in
            return MockedGetBrewPackageDescriptionUC()
        }.inObjectScope(.container)
        container.register(GetSearchedPackagesUCProtocol.self) { resolver in
            return MockedGetSearchedPackagesUC()
        }.inObjectScope(.container)
        container.register(UpdateOnePackageUCProtocol.self) { resolver in
            return MockedUpdateOnePackageUC()
        }.inObjectScope(.container)
        container.register(AreUpdatablePackagesAvailableUCProtocol.self) { resolver in
            return MockedAreUpdatablePackagesAvailableUC()
        }.inObjectScope(.container)
        container.register(UpdatePackagesUCProtocol.self) { resolver in
            return MockedUpdatePackagesUC()
        }.inObjectScope(.container)
        container.register(UpdateOutdatedPackagesTrackerUCProtocol.self) { resolver in
            return MockedUpdateOutdatedPackagesTrackerUC()
        }.inObjectScope(.container)
    }
}
