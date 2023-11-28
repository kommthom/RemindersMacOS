//
//  MyListItemsHeaderView.swift
//  RemindersMacOS
//
//  Created by David Malicke on 2/13/22.
//

import SwiftUI
import Reminders_Domain

struct MyListItemsHeaderView: View {
    let myList: MyList
    
    var body: some View {
        HStack{
            Text(myList.name)
                .font(.system(size:28))
                .fontWeight(.bold)
                .foregroundColor(Color(myList.color ?? .clear))
                .padding()
            Spacer()
            Text("\(myList.items.count)")
                .font(.system(size:32))
                .foregroundColor(Color(myList.color ?? .clear))
                .padding()
        }
    }
}

struct MyListItemsHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MyListItemsHeaderView(myList: MyList.mockedData[0])
    }
}
