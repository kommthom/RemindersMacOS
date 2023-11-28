//
//  EditListView.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.09.23.
//

import ComposableArchitecture
import SwiftUI
import Reminders_Domain

struct EditListView: View {
    
    let store: StoreOf<EditList>
    
    @StateObject private var viewModel: EditListViewModel = DIContainer.shared.resolve()
    
    var body: some View {
        WithViewStore(store, observe: \.myList) { viewStore in
            Form {
                VStack(alignment: .leading) {
                    Text("editlistitem.text.editlist")
                        .font(.headline)
                        .padding(.bottom, 20)
                    HStack {
                        Text("editlistitem.text.name")
                        TextField("", text: $viewModel.name)
                    }
                    HStack {
                        Text("editlistitem.text.color")
                        ColorListView(selectedColor: $viewModel.color)
                    }
                }
                HStack {
                    Spacer()
                    Button("button.cancel") {
                        viewStore.send(.goBackTapped)
                    }
                    Button("button.ok") {
                        viewModel.save()
                        viewStore.send(.goBackTapped)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.name.isEmpty)
                }
            }.frame(minWidth: 300)
            .padding()
            .onAppear(perform: {
                viewModel.loadViewModel(myList: viewStore.state)
            })
        }
    }
}

/*#if DEBUG
struct EditListView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Resolver.shared.buildMockContainer()
        EditListView(viewModel: .init(myList: MyList.mockedData[0]))
    }
}
#endif*/
