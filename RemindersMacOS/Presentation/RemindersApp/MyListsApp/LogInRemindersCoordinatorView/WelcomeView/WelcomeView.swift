//
//  WelcomeView.swift
//  RemindersMacOS
//
//  Created by Thomas on 02.10.23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct WelcomeView: View {
    let store: StoreOf<Welcome>

    var body: some View {
        VStack {
            Text("mylists.text.welcome").font(.headline)
            Button("button.login") {
                store.send(.logInTapped)
            }
        }
        .frame(idealWidth: Geometries.main.sidebarWidth[AppSection.reminders.rawValue], minHeight: Geometries.main.content[AppSection.reminders.rawValue].width)
    }
}
