//
//  MyList.swift
//  Reminders.MyLists
//
//  Created by Thomas on 11.11.23.
//

import Foundation
import Reminders_Domain

extension MyList {
    
    public init?(managedObject: MyListMO) {
        guard let name = managedObject.name,
              let id = managedObject.id
            else { return nil }
        let items: [MyListItem] = []
        let itemsMO = managedObject.items?.allObjects.compactMap { $0 as? MyListItemMO } //?.toArray(of: MyListItemMO.Type)
        self.init(id: id, name: name, color: managedObject.color, items: items)
        for item in itemsMO ?? [] {
            self.items.append(MyListItem(itemDescription: item.itemDescription, title: item.title, id: item.id, dueDate: item.dueDate, isCompleted: item.isCompleted, myList: self, homepage: item.homepage, comments: item.comments))
        }
    }
}
