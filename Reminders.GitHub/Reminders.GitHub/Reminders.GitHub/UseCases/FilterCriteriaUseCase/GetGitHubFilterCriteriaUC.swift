//
//  GetGitHubFilterCriteriaUC.swift
//  Reminders.GitHub
//
//  Created by Thomas on 11.11.23.
//

import Foundation
import Reminders_Domain

// MARK: - Implementation -

public class DefaultGetGitHubFilterCriteriaUC: GetGitHubFilterCriteriaUCProtocol {
    private let settingsRepository: SettingsDBRepositoryProtocol
    
    public init(settingsRepository: SettingsDBRepositoryProtocol) {
        self.settingsRepository = settingsRepository
    }
    
    public func execute() -> GitHubFilterCriteria {
        var language: String = "swift"
        var titleContains: String = "mvvm"
        
        var result = settingsRepository.getSettingByName(name: Constants.Strings.nameLanguage)
        switch result {
        case .success(let setting):
            language = setting.value
        case .failure(_):
            settingsRepository.updateAndSave(setting: Setting(id: UUID(), name: Constants.Strings.nameLanguage, value: language))
        }
        result = settingsRepository.getSettingByName(name: Constants.Strings.titleContains)
        switch result {
        case .success(let setting):
            titleContains = setting.value
        case .failure(_):
            settingsRepository.updateAndSave(setting: Setting(id: UUID(), name: Constants.Strings.titleContains, value: titleContains))
        }
        return GitHubFilterCriteria(language: language, titleContains: titleContains)
    }
}

public class MockedGetGitHubFilterCriteriaUC: GetGitHubFilterCriteriaUCProtocol {
    public func execute() -> GitHubFilterCriteria {
        GitHubFilterCriteria.mockedData[0]
    }
    
    public init() {
    }
}

