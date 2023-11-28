//
//  Constants.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.08.23.
//

import Foundation
import AppKit

public struct Constants {
    public struct Notifications {
        public static let contextChanged = Notification.Name("MyListsContextHasChanges")
        //static let applicationSection = Notification.Name("ApplicationSection")
        //static let gitHubFilterCriteriaChanged = Notification.Name("gitHubFilterCriteriaChanged")
    }
    public struct Strings {
        public static let nameLanguage: String = "GitHubFilterCriteria.language"
        public static let titleContains: String = "GitHubFilterCriteria.titleContains"
    }
}
