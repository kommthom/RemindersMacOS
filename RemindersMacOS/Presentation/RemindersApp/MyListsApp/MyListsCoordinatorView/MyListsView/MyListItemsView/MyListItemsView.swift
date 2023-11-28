//
//  MyListItemView.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.09.23.
//

import SwiftUI
import Foundation
import Reminders_Domain

struct MyListItemsView: View {
    @StateObject var viewModel: MyListItemsViewModel //= DIContainer.shared.resolve()
    var onEditListItemButtonTapped: (MyListItem) -> Void
    @State var active: Bool = false
    @State var checked: Bool = false
    private let delay: Delay = Delay()
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach($viewModel.myListItems, id: \.id) { myListItemFor in
                    let myListItem = myListItemFor.wrappedValue
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: checked ? "circle.inset.filled" : "circle")
                            .font(.system(size: 14))
                            .opacity(0.2)
                            .onTapGesture {
                                checked.toggle()
                                if checked {
                                    delay.performWork {
                                        viewModel.markAsCompleted(myListItem: myListItem)
                                    }
                                } else {
                                    delay.cancel()
                                }
                            }
                        VStack(alignment: .leading) {
                            HStack{
                                Text(myListItem.title ?? "")
                                Spacer()
                                Text(myListItem.itemDescription)
                                
                            }
                            HStack {
                                let dueDate = DueDate.from(value: myListItem.dueDate ?? Date())
                                Text(dueDate.title)
                                    .opacity(0.4)
                                    .foregroundColor(dueDate.isPastDue ? .red : .primary)
                                Spacer()
                                Text(myListItem.comments ?? "")
                                Spacer()
                                if (myListItem.homepage ?? "") == "" {
                                    Text("mylists.text.nohomepage")
                                } else {
                                    Link(myListItem.homepage ?? "", destination: URL(string: myListItem.homepage ?? "")!)
                                }
                            }
                        }
                        Spacer()
                        if active {
                            Image(systemName: "multiply.circle")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    viewModel.delete(myListItem: myListItem)
                                }
                            Image(systemName: "exclaimationmark.circle")
                                .foregroundColor(.purple)
                                .onTapGesture {
                                    onEditListItemButtonTapped(myListItem)
                                }
                        }
                    }
                    .contentShape(Rectangle())
                    .onHover { value in
                        active = value
                    }
                    Divider()
                }
                VStack(alignment: .leading) {
                    HStack(alignment: .center){
                        Image(systemName: "circle")
                            .font(.system(size: 14))
                            .opacity(0.2)
                        TextField("", text: $viewModel.newTitle)
                            .padding(.trailing)
                    }
                    Text("addlistitem.text.notes")
                        .opacity(0.2)
                        .padding(.leading, 30)
                    VStack {
                        HStack {
                            DueDateSelectionView(dueDate: $viewModel.newDueDate)
                            TextField("editlistitem.text.description", text: $viewModel.newItemDescription)
                            if viewModel.newDueDate != nil && viewModel.newItemDescription != "" {
                                Button("editlistitem.button.clear") {
                                    viewModel.initMyListItem()
                                }
                                Button("editlistitem.button.save") {
                                    viewModel.newTitle = viewModel.newDueDate?.title ?? ""
                                    viewModel.save()
                                    viewModel.initMyListItem()
                                }
                            }
                        }
                        .padding()
                        HStack {
                            TextField("editlistitem.text.comments", text: $viewModel.newComments)
                            Spacer()
                            TextField("editlistitem.text.homepage", text: $viewModel.newHomePage)
                        }
                        .padding([.leading, .trailing, .bottom])
                    }
                }
            }
        }
    }
}

/*struct MyListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MyListItemsView(myList: MyList.mockedData[0])
    }
}*/
