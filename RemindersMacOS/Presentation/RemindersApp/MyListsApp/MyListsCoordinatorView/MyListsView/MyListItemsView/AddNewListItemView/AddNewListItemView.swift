//
//  AddNewListItemView.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.09.23.
//

import SwiftUI
import Reminders_Domain

struct AddNewListItemView: View {
    
    @StateObject private var viewModel: AddNewListItemViewModel = DIContainer.shared.resolve()
    
    @State var myList: MyList
    
    var body: some View {
        let _ = viewModel.setMyList(myList: myList)
        VStack(alignment: .leading) {
            HStack(alignment: .center){
                Image(systemName: "circle")
                    .font(.system(size: 14))
                    .opacity(0.2)
                TextField("", text: $viewModel.title)
                    .padding(.trailing)
            }
            Text("addlistitem.text.notes")
                .opacity(0.2)
                .padding(.leading, 30)
            VStack {
                HStack {
                    DueDateSelectionView(dueDate: $viewModel.dueDate)
                    TextField("editlistitem.text.description", text: $viewModel.itemDescription)
                    if viewModel.dueDate != nil && viewModel.itemDescription != "" {
                        Button("editlistitem.button.clear") {
                            viewModel.title = ""
                            viewModel.dueDate = nil
                            viewModel.itemDescription = ""
                            viewModel.homepage = ""
                            viewModel.comments = ""
                        }
                        
                        Button("editlistitem.button.save") {
                            viewModel.title = viewModel.dueDate?.title ?? ""
                            viewModel.save()
                            viewModel.title = ""
                            viewModel.dueDate = nil
                            viewModel.itemDescription = ""
                            viewModel.homepage = ""
                            viewModel.comments = ""
                        }
                    }
                    
                }.padding()
                HStack {
                    TextField("editlistitem.text.comments", text: $viewModel.comments)
                    Spacer()
                    TextField("editlistitem.text.homepage", text: $viewModel.homepage)
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom)
            }
        }
    }
}

/*
//#if DEBUG
struct AddNewListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = Resolver.shared.buildMockContainer()
        AddNewListItemView(myList: MyList.mockedData[0])
    }
}
//#endif
*/
