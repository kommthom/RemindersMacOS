//
//  MyListMO+CoreDataProperties.swift
//  RemindersMacOS
//
//  Created by Thomas on 29.08.23.
//
//

import Foundation
import CoreData
import AppKit

extension MyListMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyListMO> {
        return NSFetchRequest<MyListMO>(entityName: "MyListMO")
    }

    @NSManaged public var color: NSColor?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension MyListMO {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: MyListItemMO)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: MyListItemMO)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension MyListMO : Identifiable {

}
