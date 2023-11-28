//
//  SideBarView.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.09.23.
//

import SwiftUI
import ComposableArchitecture
import Reminders_Domain

struct MyListsSideBarView: View {
    let store: StoreOf<MyListsReducer>
    @EnvironmentObject private var selectedTab: ObservableString
    @EnvironmentObject private var myListsMainVM: MyListsViewModel
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            VStack(alignment: .leading, spacing: 0) {
                switch myListsMainVM.myListsLoadable {
                case .notRequested:
                    Text("").onAppear (perform: myListsMainVM.load)
                case let .isLoading(last, _):
                    if let myLists = last {
                        AnyView(loadedMyListsView(myLists))
                    } else {
                        AnyView(ProgressView().padding())
                    }
                case let .loaded(myLists):
                    loadedMyListsView(myLists)
                case let .failed(error):
                    ErrorView(error: error, retryAction: myListsMainVM.load)
                }
            }
            .frame(minWidth: Geometries.main.sidebarWidth[AppSection.reminders.rawValue], maxWidth: .infinity, minHeight: Geometries.main.content[AppSection.reminders.rawValue].height, maxHeight: .infinity)
        } detail: {
            if let firstMyList = myListsMainVM.firstMyList {
                VStack {
                    MyListItemsHeaderView(myList: firstMyList)
                        .frame(minWidth: Geometries.main.detailWidth[AppSection.reminders.rawValue], maxWidth: .infinity, minHeight: Geometries.main.content[AppSection.reminders.rawValue].height * 0.15, maxHeight: .infinity)
                    let myListItemsVM: MyListItemsViewModel = DIContainer.shared.resolve(argument: firstMyList)
                    MyListItemsView(viewModel: myListItemsVM) { _ in
                    }
                    .frame(minWidth: Geometries.main.detailWidth[AppSection.reminders.rawValue], maxWidth: .infinity, minHeight: Geometries.main.content[AppSection.reminders.rawValue].height * 0.85, maxHeight: .infinity)
                }
            }
        }
    }
    
    func loadedMyListsView(_ myLists: LazyList<MyList>) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                AllCountView(count: myListsMainVM.allListItemsCount)
                HStack {
                    Text("mylists.title.mylists")
                    Spacer()
                    Button {
                        selectedTab.value = "gitHub"
                        //viewStore.send(.gitHubButtonTapped(""))
                    } label: {
                        Image(systemName: "arrow.forward")
                    }.buttonStyle(.plain)
                        .padding()
                }
                ForEach(myLists, id: \.id) { myList in
                    NavigationLink {
                        MyListItemsHeaderView(myList: myList)
                        let myListItemsVM: MyListItemsViewModel = DIContainer.shared.resolve(argument: myList)
                        MyListItemsView(viewModel: myListItemsVM,
                            onEditListItemButtonTapped: { myListItem in
                               //onEditListItemButtonTapped: (MyListItem) -> Void
                               viewStore.send(.editListItemButtonTapped(myListItem))
                            })
                    } label: {
                        MyListCell(myList: myList,
                            onEditListButtonTapped: { myListClosure in
                                //onEditListButtonTapped: (MyList) -> Void
                                viewStore.send(.editListButtonTapped(myListClosure))
                            }, onDeleteButtonTapped: { myListClosure in
                                //onDeleteButtonTapped: (MyList) -> Void
                                myListsMainVM.deleteMyList(myList: myListClosure)
                            })
                    }
                }
            }
            Spacer()
            Button {
                viewStore.send(.addListButtonTapped)
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("mylists.addlist")
                }
            }.buttonStyle(.plain)
                .padding()
        }
    }
}

/*#if DEBUG
struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Resolver.shared.buildMockContainer()
        MyListsSideBarView()
    }
}
#endif*/
