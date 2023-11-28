//
//  HomeBrewViewModelAssembly.swift
//  RemindersMacOS
//
//  Created by Thomas on 15.11.23.
//

import Foundation
import Swinject
import Reminders_Domain
import Reminders_Brew

final class HomeBrewViewModelAssembly: Assembly {
    @MainActor
    func assemble(container: Container) {
        container.register(HomeBrewMainViewModel.self) { resolver in
            guard let interactor = resolver.resolve(HomeBrewMainInteractorProtocol.self) else {
                fatalError("HomeBrewMainInteractorProtocol dependency could not be resolved")
            }
            return HomeBrewMainViewModel(
                interactor: interactor
            )
        }
        container.register(TapDetailViewModel.self) { (resolver, brewTapName: String) in
            guard let interactor = resolver.resolve(TapDetailInteractorProtocol.self) else {
                fatalError("TapDetailInteractorProtocol dependency could not be resolved")
            }
            return TapDetailViewModel(
                brewTapName: brewTapName, interactor: interactor
            )
        }
        container.register(PackageDetailViewModel.self) { (resolver, brewPackage: BrewPackage) in
            guard let interactor = resolver.resolve(PackageDetailInteractorProtocol.self) else {
                fatalError("PackageDetailInteractorProtocol dependency could not be resolved")
            }
            return PackageDetailViewModel(
                brewPackage: brewPackage, interactor: interactor
            )
        }
        container.register(InformationViewModel.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return InformationViewModel(
                getOutdatedPackagesUseCase: useCaseProvider.getOutdatedPackagesUC()
            )
        }
        container.register(MaintenanceViewModel.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return MaintenanceViewModel(
                removeOrphansUseCase: useCaseProvider.removeOrphansUC(),
                purgeHomebrewCacheUseCase: useCaseProvider.purgeHomebrewCacheUC(),
                deleteCachedDownloadsUseCase: useCaseProvider.deleteCachedDownloadsUC(),
                performBrewHealthCheckUseCase: useCaseProvider.performBrewHealthCheckUC()
            )
        }
        container.register(TopFormulaeViewModel.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return TopFormulaeViewModel(
                getTopFormulaeUseCase: useCaseProvider.getTopFormulaeUC()
            )
        }
        container.register(TopCasksViewModel.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return TopCasksViewModel(
                getTopCasksUseCase: useCaseProvider.getTopCasksUC()
            )
        }
        container.register(SearchFormulaeViewModel.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return SearchFormulaeViewModel(
                getSearchedPackagesUseCase: useCaseProvider.getSearchedPackagesUC()
            )
        }
        container.register(SearchCasksViewModel.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return SearchCasksViewModel(
                getSearchedPackagesUseCase: useCaseProvider.getSearchedPackagesUC()
            )
        }
        container.register(IncrementalPackagesUpdateViewModel.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return IncrementalPackagesUpdateViewModel(
                updateOnePackageUseCase: useCaseProvider.updateOnePackageUC()
            )
        }
        container.register(PackagesUpdateViewModel.self) { resolver in
            guard let useCaseProvider = resolver.resolve(UseCaseProviderProtocol.self) else {
                fatalError("UseCaseProviderProtocol dependency could not be resolved")
            }
            return PackagesUpdateViewModel(
                areUpdatablePackagesAvailableUseCase: useCaseProvider.areUpdatablePackagesAvailableUC(),
                updatePackagesUseCase: useCaseProvider.updatePackagesUC(),
                updateOutdatedPackagesTrackerUseCase: useCaseProvider.updateOutdatedPackagesTrackerUC()
            )
        }
    }
}
