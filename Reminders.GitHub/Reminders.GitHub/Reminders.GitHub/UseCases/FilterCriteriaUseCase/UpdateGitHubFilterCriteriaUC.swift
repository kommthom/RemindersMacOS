//
//  UpdateGitHubFilterCriteriaUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 28.09.23.
//


import Foundation
import Reminders_Domain

// MARK: - Implementation -

public class DefaultGUpdateGitHubFilterCriteriaUC: UpdateGitHubFilterCriteriaUCProtocol {
    private let settingsRepository: SettingsDBRepositoryProtocol
    
    public init(settingsRepository: SettingsDBRepositoryProtocol) {
        self.settingsRepository = settingsRepository
    }
    
    public func execute(gitHubFilterCriteria: GitHubFilterCriteria) {
        var setting: Setting
        var result = settingsRepository.getSettingByName(name: Constants.Strings.nameLanguage)
        switch result {
        case .success(let settingResult):
            setting = settingResult
            setting.value = gitHubFilterCriteria.language
        case .failure(_):
            setting = Setting(id: UUID(), name: Constants.Strings.nameLanguage, value: gitHubFilterCriteria.language)
        }
        settingsRepository.updateAndSave(setting: setting)
        result = settingsRepository.getSettingByName(name: Constants.Strings.titleContains)
        switch result {
        case .success(let settingResult):
            setting = settingResult
            setting.value = gitHubFilterCriteria.titleContains
        case .failure(_):
            setting = Setting(id: UUID(), name: Constants.Strings.titleContains, value: gitHubFilterCriteria.titleContains)
        }
        settingsRepository.updateAndSave(setting: setting)
    }
}

public class MockedUpdateGitHubFilterCriteriaUC: UpdateGitHubFilterCriteriaUCProtocol {
    public func execute(gitHubFilterCriteria: GitHubFilterCriteria) {
    }
    
    public init() {
    }
}
