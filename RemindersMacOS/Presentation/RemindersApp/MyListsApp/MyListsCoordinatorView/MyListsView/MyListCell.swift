//
//  MyListCell.swift
//  RemindersMacOS
//
//  Created by Thomas on 28.09.23.
//

import SwiftUI
import ComposableArchitecture
import Reminders_Domain

struct MyListCell: View {
    @State private var active: Bool = false
    @State private var showPopOver: Bool = false
    @State var myList: MyList
    var onEditListButtonTapped: (MyList) -> Void
    var onDeleteButtonTapped: (MyList) -> Void
    @EnvironmentObject private var selectedTab: ObservableString
    @EnvironmentObject var searchGitHubUser: ObservableString
    
    var body: some View {
        HStack {
            Image(systemName: "line.3.horizontal.circle.fill")
                .font(.title)
                .foregroundColor(Color(myList.color ?? .clear))
            Text(myList.name)
            Spacer()
            Text("\(myList.items.count)")
            if active {
                Image(systemName: "multiply.circle")
                    .foregroundColor(.red)
                    .onTapGesture {
                        onDeleteButtonTapped(myList)
                    }
                Image(systemName: "exclaimationmark.circle")
                    .foregroundColor(.purple)
                    .onTapGesture {
                        onEditListButtonTapped(myList)
                    }
                Image(systemName: "arrow.forward")
                    .foregroundColor(.purple)
                    .onTapGesture {
                        //navigate to GitHub selectedProjectName = userName
                        searchGitHubUser.value = myList.name
                        selectedTab.value = "gitHub"
                    }
            }
        }
        .contentShape(Rectangle())
        .onHover { value in
            if !showPopOver {
                active = value
            }
        }
    }
}

/*#if DEBUG
#Preview {
    let _ = Resolver.shared.buildMockContainer()
    return MyListCell(viewModel: .init(myList: MyList.mockedData[0]))
}
#endif*/
