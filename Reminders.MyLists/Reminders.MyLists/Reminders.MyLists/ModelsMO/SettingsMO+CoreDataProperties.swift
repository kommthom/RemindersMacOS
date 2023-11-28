//
//  SettingsMO+CoreDataProperties.swift
//  RemindersMacOS
//
//  Created by Thomas on 11.11.23.
//
//

import Foundation
import CoreData


extension SettingsMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingsMO> {
        return NSFetchRequest<SettingsMO>(entityName: "SettingsMO")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var value: String?

}

extension SettingsMO : Identifiable {

}
