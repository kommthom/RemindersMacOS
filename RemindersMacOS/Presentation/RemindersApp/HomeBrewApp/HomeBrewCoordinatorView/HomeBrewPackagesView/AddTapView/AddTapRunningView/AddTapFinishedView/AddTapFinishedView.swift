//
//  AddTapFinishedView.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.10.23.
//

import SwiftUI
import ComposableArchitecture
import Reminders_Domain

struct AddTapFinishedView: View {
    let store: StoreOf<AddTapFinished>
    @EnvironmentObject var availableTaps: AvailableTaps
    
    init(store: StoreOf<AddTapFinished>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "checkmark.seal")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.secondary)
                    VStack(alignment: .leading) {
                        Text("add-tap.complete-\(viewStore.state.tapName)")
                            .font(.headline)
                        Text("add-tap.complete.description")
                    }
                    .fixedSize(horizontal: true, vertical: true)
                    .onAppear {
                        let _ = withAnimation {
                            availableTaps.addedTaps.insert(BrewTap(name: viewStore.state.tapName)) //, at: 0) only for arrays
                        }
                        /// Remove that one element of the array that's empty for some reason
                        if let index = availableTaps.addedTaps.firstIndex(where: { $0.name == "" }) {
                            availableTaps.addedTaps.remove(at: index)      //All(where: { $0.name == "" })
                        }
                        Delay(3).performWork {
                            viewStore.send(.goBackToRootTapped)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

/*#Preview {
    AddTapFinishedView()
}*/
