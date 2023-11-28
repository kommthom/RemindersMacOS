//
//  KeyChainConstants.swift
//  RemindersMacOS
//
//  Created by Thomas on 05.10.23.
//

import Foundation

// Name of service
internal let secretsService: String = "RemindersSecretsService"

/*
Private enum to return possible errors
*/
internal enum Errors: Error {
    // Error with the keychain creting and checking
    case keychainCreatingError
    case operationError
}
