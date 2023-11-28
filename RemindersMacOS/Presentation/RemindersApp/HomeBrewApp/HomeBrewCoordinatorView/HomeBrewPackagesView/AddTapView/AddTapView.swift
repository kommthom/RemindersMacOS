//
//  AddTapView.swift
//  RemindersMacOS
//
//  Created by Thomas on 23.10.23.
//

import SwiftUI
import ComposableArchitecture
import Reminders_Domain

struct AddTapView: View {
    let store: StoreOf<AddTap>
    
    @State private var requestedTap: String = ""
    @State private var isShowingErrorPopover: Bool = false
    @State var tapInputError: TapInputErrors = .empty
    
    init(store: StoreOf<AddTap>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            VStack {
                VStack(alignment: .leading) {
                    Text("add-tap")
                        .font(.headline)
                    TextField("homebrew/core", text: $requestedTap)
                        .onSubmit {
                            isShowingErrorPopover = checkIfTapNameIsValid(tapName: requestedTap)
                        }
                        .popover(isPresented: $isShowingErrorPopover) {
                            VStack(alignment: .leading) {
                                switch tapInputError {
                                case .empty:
                                    Text("add-tap.typing.error.empty")
                                        .font(.headline)
                                    Text("add-tap.typing.error.empty.description")
                                case .missingSlash:
                                    Text("add-tap.typing.error.slash")
                                        .font(.headline)
                                    Text("add-tap.typing.error.slash.description")
                                }
                            }
                            .padding()
                        }
                    HStack {
                        Button {
                            viewStore.send(.goBackTapped)
                        } label: {
                            Text("action.cancel")
                        }
                        .keyboardShortcut(.cancelAction)
                        Spacer()
                        Button {
                            
                            if !checkIfTapNameIsValid(tapName: requestedTap) {
                                viewStore.send(.addTapRunningButtonTapped(requestedTap))
                            }
                        } label: {
                            Text("add-tap.action")
                        }
                        .keyboardShortcut(.defaultAction)
                        .disabled(validateTapName(tapName: requestedTap) != nil)
                    }
                    .frame(minWidth: 300)
                }
            }
        }
        .padding()
    }
    
    private func validateTapName(tapName: String) -> TapInputErrors? {
        if tapName.isEmpty {
            return .empty
        } else if !tapName.contains("/") {
            return .missingSlash
        }
        return nil
    }

    private func checkIfTapNameIsValid(tapName: String) -> Bool {
        if let error = validateTapName(tapName: tapName) {
            tapInputError = error
            return true
        }
        return false
    }
}

/*#Preview {
    AddTapView()
}*/
