//
//  NavigationSection.swift
//  RemindersMacOS
//
//  Created by Thomas on 19.11.23.
//


import SwiftUI
import Reminders_Domain

struct NavigationSection: View {
    var onButtonTapped: (_ buttonTapped: ButtonTapped) -> Void
    
    var body: some View {
        Section("sidebar.section.navigation") {
            NavigationLink() {
                InformationView() { buttonTapped in
                    onButtonTapped(buttonTapped)
                }
            } label: {
                Text("homebrew.navigation.startpage")
            }
        }
        .collapsible(false)
    }
}

#Preview {
    NavigationSection() {buttonTapped in
    }
}
