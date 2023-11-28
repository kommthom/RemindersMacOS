//
//  Model+CoreData.swift
//  RemindersMacOS
//
//  Created by Thomas on 20.08.23.
//

import Foundation
import CoreData
import Reminders_Domain

extension MyList {
    
    @discardableResult
    public func store(in context: NSManagedObjectContext) -> MyListMO? {
        let myList = MyListMO(context: context)//NSEntityDescription.insertNewObject(forEntityName: MyListMO.entityDescription, into: context)
        myList.name = name
        myList.id = id
        myList.color = color
        for item in items {
            let myListItem = MyListItemMO(context: context)
            if myListItem == myListItem {
                myListItem.itemDescription = item.itemDescription
                myListItem.title = item.title
                myListItem.id = item.id
                myListItem.dueDate = item.dueDate
                myListItem.isCompleted = item.isCompleted
                myListItem.myList = myList
                myListItem.homepage = item.homepage
                myListItem.comments = item.comments
                myList.addToItems(myListItem)
            }
        }
        return myList
    }
}
