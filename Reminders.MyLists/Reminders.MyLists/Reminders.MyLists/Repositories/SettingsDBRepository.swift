//
//  DefaultSettingsDBRepository.swift
//  RemindersMacOS
//
//  Created by Thomas on 28.09.23.
//

import Foundation
import Reminders_Domain

public struct DefaultSettingsDBRepository: SettingsDBRepositoryProtocol {
    
    private let dataSource: RemindersDataSourceProtocol
    
    public init(dataSource: RemindersDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    public func updateAndSave(setting: Setting) {
        let predicate = NSPredicate(format: "id = %@", setting.id as CVarArg)
        let result = dataSource.fetchFirst(SettingsMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let settingMO = managedObject {
                update(settingMO: settingMO, from: setting)
            } else {
                createSettingMO(from: setting)
            }
            dataSource.saveData()
        case .failure(_):
            AppLogger.reminders.log("Couldn't fetch SettingMO to save")
        }
    }
    
    private func update(settingMO: SettingsMO, from setting: Setting) {
        settingMO.name = setting.name
        settingMO.value = setting.value
    }
    
    private func getSettingMO(from setting: Setting?) -> SettingsMO? {
        guard let setting = setting else { return nil }
        let predicate = NSPredicate(format: "id = %@", setting.id as CVarArg)
        let result = dataSource.fetchFirst(SettingsMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let settingMO = managedObject {
                return settingMO
            } else {
                return nil
            }
        case .failure(_):
            return nil
        }
    }
    
    private func createSettingMO(from setting: Setting) {
        let settingMO = dataSource.newSettingMO()
        settingMO.id = setting.id
        update(settingMO: settingMO, from: setting)
    }
    
    public func delete(setting: Setting) {
        let predicate = NSPredicate(format: "id = %@", setting.id as CVarArg)
        let result = dataSource.fetchFirst(SettingsMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let settingMO = managedObject {
                dataSource.deleteObject(myMO: settingMO)
            }
        case .failure(_):
            AppLogger.reminders.log("Couldn't fetch SettingsMO to save")
        }
    }
    
    public func getSettingByName(name: String) -> Result<Setting, Error> {
        let predicate = NSPredicate(format: "name = %@", name as CVarArg)
        let result = dataSource.fetchFirst(SettingsMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let _ = managedObject {
                return .success(Setting(managedObject: managedObject)!)
            } else {
                return .failure(FetchRecordError.invalidResponse)
            }
            // AnyPublisher: return Just(Setting(managedObject: managedObject)!)
            //    .setFailureType(to: Error.self)
            //    .eraseToAnyPublisher()
        case .failure(let error):
            return .failure(error)
            // AnyPublisher: return Fail(error: error)
            //   .eraseToAnyPublisher()
        }
    }
    
    public func logInReminders(username: String, password: String) -> Bool {
        let settingUserName = "RemindersUserName"
        let settingPassword = "RemindersPassword"
        return testSetting(settingName: settingUserName, settingValue: username) && testSetting(settingName: settingPassword, settingValue: password)
    }
    
    private func testSetting(settingName: String, settingValue: String) -> Bool {
        let result = getSettingByName(name: settingName)
        switch result {
        case .success(let setting):
            return (settingValue == setting.value)
        case .failure(_):
            updateAndSave(setting: Setting(id: UUID(), name: settingName, value: settingValue))
            return true
        }
    }
}

public struct MockedSettingsDBRepository: SettingsDBRepositoryProtocol {
    public func delete(setting: Setting) {
    }
    
    public func updateAndSave(setting: Setting) {
    }
    
    public func getSettingByName(name: String) -> Result<Setting, Error> {
        .success(Setting.mockedData[0])
        // AnyPublisher: return Just(Setting.mockedData[0])
            //.setFailureType(to: Error.self)
            //.eraseToAnyPublisher()
    }
    
    public func logInReminders(username: String, password: String) -> Bool {
        true
    }
}

