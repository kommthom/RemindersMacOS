//
//  UseCaseProvider.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.11.23.
//

import Foundation
import Reminders_Domain

public class DefaultUseCaseProvider: UseCaseProviderProtocol {
    public func getOutdatedPackagesUC() -> GetOutdatedPackagesUCProtocol {
        guard let useCase: GetOutdatedPackagesUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetOutdatedPackagesUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getSearchedPackagesUC() -> GetSearchedPackagesUCProtocol {
        guard let useCase: GetSearchedPackagesUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetSearchedPackagesUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func updateOutdatedPackagesTrackerUC() -> UpdateOutdatedPackagesTrackerUCProtocol {
        guard let useCase: UpdateOutdatedPackagesTrackerUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UpdateOutdatedPackagesTrackerUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func removeOrphansUC() -> RemoveOrphansUCProtocol {
        guard let useCase: RemoveOrphansUCProtocol = DIContainer.shared.resolve() else {
            fatalError("RemoveOrphansUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func purgeHomebrewCacheUC() -> PurgeHomebrewCacheUCProtocol {
        guard let useCase: PurgeHomebrewCacheUCProtocol = DIContainer.shared.resolve() else {
            fatalError("PurgeHomebrewCacheUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func uninstallPackageUC() -> UninstallPackageUCProtocol {
        guard let useCase: UninstallPackageUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UninstallPackageUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func deleteCachedDownloadsUC() -> DeleteCachedDownloadsUCProtocol {
        guard let useCase: DeleteCachedDownloadsUCProtocol = DIContainer.shared.resolve() else {
            fatalError("DeleteCachedDownloadsUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func performBrewHealthCheckUC() -> PerformBrewHealthCheckUCProtocol {
        guard let useCase: PerformBrewHealthCheckUCProtocol = DIContainer.shared.resolve() else {
            fatalError("PerformBrewHealthCheckUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getTopFormulaeUC() -> GetTopFormulaeUCProtocol {
        guard let useCase: GetTopFormulaeUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetTopFormulaeUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func updatePackagesUC() -> UpdatePackagesUCProtocol {
        guard let useCase: UpdatePackagesUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UpdatePackagesUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func addPackageUC() -> AddPackageUCProtocol {
        guard let useCase: AddPackageUCProtocol = DIContainer.shared.resolve() else {
            fatalError("AddPackageUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getTopCasksUC() -> GetTopCasksUCProtocol {
        guard let useCase: GetTopCasksUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetTopCasksUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getBrewPackageInfoUC() -> GetBrewPackageInfoUCProtocol {
        guard let useCase: GetBrewPackageInfoUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetBrewPackageInfoUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func uninstallTapUC() -> UninstallTapUCProtocol {
        guard let useCase: UninstallTapUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UninstallTapUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func addTapUC() -> AddTapUCProtocol {
        guard let useCase: AddTapUCProtocol = DIContainer.shared.resolve() else {
            fatalError("AddTapUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getBrewTapInfoUC() -> GetBrewTapInfoUCProtocol {
        guard let useCase: GetBrewTapInfoUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetBrewTapInfoUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getSearchedPackagesUCProtocol() -> GetSearchedPackagesUCProtocol {
        guard let useCase: GetSearchedPackagesUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetSearchedPackagesUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getHomeBrewCasksUC() -> GetHomeBrewCasksUCProtocol {
        guard let useCase: GetHomeBrewCasksUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetHomeBrewCasksUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getBrewPackageDescriptionUC() -> GetBrewPackageDescriptionUCProtocol {
        guard let useCase: GetBrewPackageDescriptionUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetBrewPackageDescriptionUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func pinAndUnpinPackageUC() -> PinAndUnpinPackageUCProtocol {
        guard let useCase: PinAndUnpinPackageUCProtocol = DIContainer.shared.resolve() else {
            fatalError("PinAndUnpinPackageUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func areUpdatablePackagesAvailableUC() -> AreUpdatablePackagesAvailableUCProtocol {
        guard let useCase: AreUpdatablePackagesAvailableUCProtocol = DIContainer.shared.resolve() else {
            fatalError("AreUpdatablePackagesAvailableUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func updateOnePackageUC() -> UpdateOnePackageUCProtocol {
        guard let useCase: UpdateOnePackageUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UpdateOnePackageUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getHomeBrewTapsUC() -> GetHomeBrewTapsUCProtocol {
        guard let useCase: GetHomeBrewTapsUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetHomeBrewTapsUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getHomeBrewFormulaeUC() -> GetHomeBrewFormulaeUCProtocol {
        guard let useCase: GetHomeBrewFormulaeUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetHomeBrewFormulaeUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func updateGitHubFilterCriteriaUC() -> UpdateGitHubFilterCriteriaUCProtocol {
        guard let useCase: UpdateGitHubFilterCriteriaUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UpdateGitHubFilterCriteriaUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getGitHubFilterCriteriaUC() -> GetGitHubFilterCriteriaUCProtocol {
        guard let useCase: GetGitHubFilterCriteriaUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetGitHubFilterCriteriaUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func setStarredUC() -> SetStarredUCProtocol {
        guard let useCase: SetStarredUCProtocol = DIContainer.shared.resolve() else {
            fatalError("SetStarredUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getRepositoryUC() -> GetRepositoryUCProtocol {
        guard let useCase: GetRepositoryUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetRepositoryUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getImageUC() -> GetImageUCProtocol {
        guard let useCase: GetImageUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetImageUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getCurrentUserStarredUC() -> GetCurrentUserStarredUCProtocol {
        guard let useCase: GetCurrentUserStarredUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetCurrentUserStarredUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getUserRepositoriesUC() -> GetUserRepositoriesUCProtocol {
        guard let useCase: GetUserRepositoriesUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetUserRepositoriesUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getActiveRepositoriesUC() -> GetActiveRepositoriesUCProtocol {
        guard let useCase: GetActiveRepositoriesUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetActiveRepositoriesUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func isAuthenticatedUC() -> IsAuthenticatedUCProtocol {
        guard let useCase: IsAuthenticatedUCProtocol = DIContainer.shared.resolve() else {
            fatalError("IsAuthenticatedUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func logOutUC() -> LogOutUCProtocol {
        guard let useCase: LogOutUCProtocol = DIContainer.shared.resolve() else {
            fatalError("LogOutUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func logInUC() -> LogInUCProtocol {
        guard let useCase: LogInUCProtocol = DIContainer.shared.resolve() else {
            fatalError("LogInUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func logInRemindersUC() -> LogInRemindersUCProtocol {
        guard let useCase: LogInRemindersUCProtocol = DIContainer.shared.resolve() else {
            fatalError("LogInRemindersUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func updateMyListUC() -> UpdateMyListUCProtocol {
        guard let useCase: UpdateMyListUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UpdateMyListUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func createMyListUC() -> CreateMyListUCProtocol {
        guard let useCase: CreateMyListUCProtocol = DIContainer.shared.resolve() else {
            fatalError("CreateMyListUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getMyListsUC() -> GetMyListsUCProtocol {
        guard let useCase: GetMyListsUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetMyListsUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func deleteMyListUC() -> DeleteMyListUCProtocol {
        guard let useCase: DeleteMyListUCProtocol = DIContainer.shared.resolve() else {
            fatalError("DeleteMyListUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func deleteMyListItemUC() -> DeleteMyListItemUCProtocol {
        guard let useCase: DeleteMyListItemUCProtocol = DIContainer.shared.resolve() else {
            fatalError("DeleteMyListItemUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func updateMyListItemUC() -> UpdateMyListItemUCProtocol {
        guard let useCase: UpdateMyListItemUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UpdateMyListItemUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func createMyListItemUC() -> CreateMyListItemUCProtocol {
        guard let useCase: CreateMyListItemUCProtocol = DIContainer.shared.resolve() else {
            fatalError("CreateMyListItemUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func createMyListItemIfNewUC() -> CreateMyListItemIfNewUCProtocol {
        guard let useCase: CreateMyListItemIfNewUCProtocol = DIContainer.shared.resolve() else {
            fatalError("CreateMyListItemIfNewUCProtocol could not be resolved")
        }
        return useCase
    }
}

public class MockedUseCaseProvider: UseCaseProviderProtocol {
    public func getSearchedPackagesUC() -> GetSearchedPackagesUCProtocol {
        guard let useCase: GetSearchedPackagesUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetSearchedPackagesUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func updateOutdatedPackagesTrackerUC() -> UpdateOutdatedPackagesTrackerUCProtocol {
        guard let useCase: UpdateOutdatedPackagesTrackerUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UpdateOutdatedPackagesTrackerUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getOutdatedPackagesUC() -> GetOutdatedPackagesUCProtocol {
        guard let useCase: GetOutdatedPackagesUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetOutdatedPackagesUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func removeOrphansUC() -> RemoveOrphansUCProtocol {
        guard let useCase: RemoveOrphansUCProtocol = DIContainer.shared.resolve() else {
            fatalError("RemoveOrphansUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func purgeHomebrewCacheUC() -> PurgeHomebrewCacheUCProtocol {
        guard let useCase: PurgeHomebrewCacheUCProtocol = DIContainer.shared.resolve() else {
            fatalError("PurgeHomebrewCacheUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func uninstallPackageUC() -> UninstallPackageUCProtocol {
        guard let useCase: UninstallPackageUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UninstallPackageUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func deleteCachedDownloadsUC() -> DeleteCachedDownloadsUCProtocol {
        guard let useCase: DeleteCachedDownloadsUCProtocol = DIContainer.shared.resolve() else {
            fatalError("DeleteCachedDownloadsUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func performBrewHealthCheckUC() -> PerformBrewHealthCheckUCProtocol {
        guard let useCase: PerformBrewHealthCheckUCProtocol = DIContainer.shared.resolve() else {
            fatalError("PerformBrewHealthCheckUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getTopFormulaeUC() -> GetTopFormulaeUCProtocol {
        guard let useCase: GetTopFormulaeUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetTopFormulaeUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func updatePackagesUC() -> UpdatePackagesUCProtocol {
        guard let useCase: UpdatePackagesUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UpdatePackagesUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func addPackageUC() -> AddPackageUCProtocol {
        guard let useCase: AddPackageUCProtocol = DIContainer.shared.resolve() else {
            fatalError("AddPackageUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getTopCasksUC() -> GetTopCasksUCProtocol {
        guard let useCase: GetTopCasksUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetTopCasksUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getBrewPackageInfoUC() -> GetBrewPackageInfoUCProtocol {
        guard let useCase: GetBrewPackageInfoUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetBrewPackageInfoUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func uninstallTapUC() -> UninstallTapUCProtocol {
        guard let useCase: UninstallTapUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UninstallTapUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func addTapUC() -> AddTapUCProtocol {
        guard let useCase: AddTapUCProtocol = DIContainer.shared.resolve() else {
            fatalError("AddTapUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getBrewTapInfoUC() -> GetBrewTapInfoUCProtocol {
        guard let useCase: GetBrewTapInfoUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetBrewTapInfoUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getSearchedPackagesUCProtocol() -> GetSearchedPackagesUCProtocol {
        guard let useCase: GetSearchedPackagesUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetSearchedPackagesUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getHomeBrewCasksUC() -> GetHomeBrewCasksUCProtocol {
        guard let useCase: GetHomeBrewCasksUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetHomeBrewCasksUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getBrewPackageDescriptionUC() -> GetBrewPackageDescriptionUCProtocol {
        guard let useCase: GetBrewPackageDescriptionUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetBrewPackageDescriptionUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func pinAndUnpinPackageUC() -> PinAndUnpinPackageUCProtocol {
        guard let useCase: PinAndUnpinPackageUCProtocol = DIContainer.shared.resolve() else {
            fatalError("PinAndUnpinPackageUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func areUpdatablePackagesAvailableUC() -> AreUpdatablePackagesAvailableUCProtocol {
        guard let useCase: AreUpdatablePackagesAvailableUCProtocol = DIContainer.shared.resolve() else {
            fatalError("AreUpdatablePackagesAvailableUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func updateOnePackageUC() -> UpdateOnePackageUCProtocol {
        guard let useCase: UpdateOnePackageUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UpdateOnePackageUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getHomeBrewTapsUC() -> GetHomeBrewTapsUCProtocol {
        guard let useCase: GetHomeBrewTapsUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetHomeBrewTapsUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getHomeBrewFormulaeUC() -> GetHomeBrewFormulaeUCProtocol {
        guard let useCase: GetHomeBrewFormulaeUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetHomeBrewFormulaeUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func updateGitHubFilterCriteriaUC() -> UpdateGitHubFilterCriteriaUCProtocol {
        guard let useCase: UpdateGitHubFilterCriteriaUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UpdateGitHubFilterCriteriaUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getGitHubFilterCriteriaUC() -> GetGitHubFilterCriteriaUCProtocol {
        guard let useCase: GetGitHubFilterCriteriaUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetGitHubFilterCriteriaUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func setStarredUC() -> SetStarredUCProtocol {
        guard let useCase: SetStarredUCProtocol = DIContainer.shared.resolve() else {
            fatalError("SetStarredUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getRepositoryUC() -> GetRepositoryUCProtocol {
        guard let useCase: GetRepositoryUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetRepositoryUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getImageUC() -> GetImageUCProtocol {
        guard let useCase: GetImageUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetImageUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getCurrentUserStarredUC() -> GetCurrentUserStarredUCProtocol {
        guard let useCase: GetCurrentUserStarredUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetCurrentUserStarredUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getUserRepositoriesUC() -> GetUserRepositoriesUCProtocol {
        guard let useCase: GetUserRepositoriesUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetUserRepositoriesUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getActiveRepositoriesUC() -> GetActiveRepositoriesUCProtocol {
        guard let useCase: GetActiveRepositoriesUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetActiveRepositoriesUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func isAuthenticatedUC() -> IsAuthenticatedUCProtocol {
        guard let useCase: IsAuthenticatedUCProtocol = DIContainer.shared.resolve() else {
            fatalError("IsAuthenticatedUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func logOutUC() -> LogOutUCProtocol {
        guard let useCase: LogOutUCProtocol = DIContainer.shared.resolve() else {
            fatalError("LogOutUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func logInUC() -> LogInUCProtocol {
        guard let useCase: LogInUCProtocol = DIContainer.shared.resolve() else {
            fatalError("LogInUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func logInRemindersUC() -> LogInRemindersUCProtocol {
        guard let useCase: LogInRemindersUCProtocol = DIContainer.shared.resolve() else {
            fatalError("LogInRemindersUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func updateMyListUC() -> UpdateMyListUCProtocol {
        guard let useCase: UpdateMyListUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UpdateMyListUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func createMyListUC() -> CreateMyListUCProtocol {
        guard let useCase: CreateMyListUCProtocol = DIContainer.shared.resolve() else {
            fatalError("CreateMyListUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func getMyListsUC() -> GetMyListsUCProtocol {
        guard let useCase: GetMyListsUCProtocol = DIContainer.shared.resolve() else {
            fatalError("GetMyListsUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func deleteMyListUC() -> DeleteMyListUCProtocol {
        guard let useCase: DeleteMyListUCProtocol = DIContainer.shared.resolve() else {
            fatalError("DeleteMyListUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func deleteMyListItemUC() -> DeleteMyListItemUCProtocol {
        guard let useCase: DeleteMyListItemUCProtocol = DIContainer.shared.resolve() else {
            fatalError("DeleteMyListItemUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func updateMyListItemUC() -> UpdateMyListItemUCProtocol {
        guard let useCase: UpdateMyListItemUCProtocol = DIContainer.shared.resolve() else {
            fatalError("UpdateMyListItemUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func createMyListItemUC() -> CreateMyListItemUCProtocol {
        guard let useCase: CreateMyListItemUCProtocol = DIContainer.shared.resolve() else {
            fatalError("CreateMyListItemUCProtocol could not be resolved")
        }
        return useCase
    }
    
    public func createMyListItemIfNewUC() -> CreateMyListItemIfNewUCProtocol {
        guard let useCase: CreateMyListItemIfNewUCProtocol = DIContainer.shared.resolve() else {
            fatalError("CreateMyListItemIfNewUCProtocol could not be resolved")
        }
        return useCase
    }
}
