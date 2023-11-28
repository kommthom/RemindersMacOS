//
//  MyListItemMO+CoreDataProperties.swift
//  Reminders.MyLists
//
//  Created by Thomas on 19.11.23.
//
//

import Foundation
import CoreData


extension MyListItemMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyListItemMO> {
        return NSFetchRequest<MyListItemMO>(entityName: "MyListItemMO")
    }

    @NSManaged public var comments: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var homepage: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var itemDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var myList: MyListMO?

}

extension MyListItemMO : Identifiable {

}
