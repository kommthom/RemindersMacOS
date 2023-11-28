//
//  AddTapRunningView.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.10.23.
//

import SwiftUI
import ComposableArchitecture
import Reminders_Domain
import Reminders_Brew

struct AddTapRunningView: View {
    let store: StoreOf<AddTapRunning>
    
    @StateObject var viewModel: AddTapViewModel = DIContainer.shared.resolve()
    @State var currentMaintenanceStepText: LocalizedStringKey = "addTap.step.initial"
    
    init(store: StoreOf<AddTapRunning>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            VStack {
                switch viewModel.actionSuccess {
                case .notRequested:
                    Text(currentMaintenanceStepText)
                        .onAppear(perform: {
                            viewModel.startAddingTap(tapName: viewStore.state.tapName)
                            currentMaintenanceStepText = "add-tap.progress-\(viewStore.state.tapName)"
                        }
                    )
                case .isExecuting(_, _):
                    ProgressView {
                        Text(currentMaintenanceStepText)
                    }
                case .executed(let actionSuccess):
                    switch actionSuccess {
                    case .boolType(let success):
                        let _ = viewStore.send(.addTapFinishedButtonTapped(viewStore.state.tapName, success))
                    case .intType(_), .stringType(_), .stringArrayType(_):
                        let _ = viewStore.send(.addTapFinishedButtonTapped(viewStore.state.tapName, false))
                    }
                    Text("action.success")
                case .failed(let error):
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "xmark.seal")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.secondary)
                        VStack(alignment: .leading, spacing: 5) {
                            switch error {
                            case TappingError.repositoryNotFound:
                                Text("add-tap.error.repository-not-found-\(viewStore.state.tapName)")
                                    .font(.headline)
                                Text("add-tap.error.repository-not-found.description")
                            case TappingError.other:
                                Text("add-tap.error.other-\(viewStore.state.tapName)")
                                    .font(.headline)
                                Text("add-tap.error.other.description")
                            default:
                                Text(error.localizedDescription)
                            }
                            HStack {
                                Button {
                                    viewStore.send(.goBackToRootTapped)
                                } label: {
                                    Text("action.cancel")
                                }
                                .keyboardShortcut(.cancelAction)
                                Spacer()
                                Button {
                                    viewStore.send(.goBackTapped)
                                } label: {
                                    Text("add-tap.error.action")
                                }
                                .keyboardShortcut(.defaultAction)
                            }
                        }
                        .frame(width: 200)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding()
    }
}

/*#Preview {
    AddTapRunningView()
}*/
