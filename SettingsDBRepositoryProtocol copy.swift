//
//  SettingsDBRepositoryProtocol.swift
//  RemindersMacOS
//
//  Created by Thomas on 28.09.23.
//

import Foundation
import Combine

public protocol SettingsDBRepositoryProtocol {
    
    func updateAndSave(setting: Setting)
    func delete(setting: Setting)
    func getSettingByName(name: String) -> Result<Setting, Error>
    func logInReminders(username: String, password: String) -> Bool
}
