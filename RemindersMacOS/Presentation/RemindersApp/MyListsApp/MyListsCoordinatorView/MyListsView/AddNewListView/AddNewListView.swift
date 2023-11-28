//
//  AddNewListView.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.09.23.
//

import SwiftUI
import ComposableArchitecture

struct AddNewListView: View {
    
    let store: StoreOf<AddNewList>
    
    @StateObject private var viewModel: AddNewListViewModel = DIContainer.shared.resolve()
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {
                VStack(alignment: .leading) {
                    /*Text("New Project")
                        .font(.headline)
                        .padding(.bottom, 20)*/
                    HStack {
                        Text("addlistitem.text.name:")
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
                    }.disabled(viewModel.name.isEmpty)
                }
            }
            .navigationTitle("addnewlist.title.newlist")
            .frame(minWidth: 300)
            .padding()
        }
    }
}

/*#if DEBUG
struct AddNewListView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Resolver.shared.buildMockContainer()
        AddNewListView(viewModel: Resolver.shared.resolve(AddNewListViewModel.self))
    }
}
#endif*/
