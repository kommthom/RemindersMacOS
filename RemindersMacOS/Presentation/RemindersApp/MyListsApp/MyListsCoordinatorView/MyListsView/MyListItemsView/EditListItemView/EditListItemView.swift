//
//  EditListItemView.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.09.23.
//

import SwiftUI
import ComposableArchitecture
import Reminders_Domain

struct EditListItemView: View {
    let store: StoreOf<EditListItem>
    //@Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: EditListItemViewModel = DIContainer.shared.resolve()
    @State private var showCalendar: Bool = false
    
    var calendarButtonTitle: String {
        viewModel.dueDate != nil ? viewModel.dueDate!.formatAsString : "editlistitem.text.adddate"
    }
    
    var body: some View {
        WithViewStore(store, observe: \.myListItem) { viewStore in
            VStack(alignment: .leading) {
                TextField(viewModel.title, text: $viewModel.title)
                    .textFieldStyle(.plain)
                Divider()
                HStack {
                    Text("editlistitem.text.duedate")
                    CalendarButtonView(title: calendarButtonTitle, showCalendar: $showCalendar) { selectedDate in
                        viewModel.dueDate = selectedDate
                    }
                }
                Divider()
                TextField(viewModel.itemDescription, text: $viewModel.itemDescription)
                    .textFieldStyle(.plain)
                Divider()
                TextField(viewModel.homepage, text: $viewModel.homepage)
                    .textFieldStyle(.plain)
                    .padding(.bottom)
                TextField(viewModel.comments, text: $viewModel.comments)
                    .textFieldStyle(.plain)
                Spacer()
                HStack {
                    Spacer()
                    Button("button.cancel") {
                        viewStore.send(.goBackTapped)
                        //presentationMode.wrappedValue.dismiss()
                    }
                    Button("button.done") {
                        viewModel.save()
                        viewStore.send(.goBackTapped)
                        //presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.title.isEmpty)
                }
            }
            .onAppear(perform: {
                viewModel.loadViewModel(myListItem: viewStore.state)
            })
            .padding()
            .frame(minWidth: 200, minHeight: 200)
        }
    }
}

/*#if DEBUG
struct EditListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Resolver.shared.buildMockContainer()
        EditListItemView(viewModel: .init(myListItem: MyListItem.mockedData[0]))
    }
}
#endif*/
