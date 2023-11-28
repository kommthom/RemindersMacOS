//
//  RemindersMacOSApp.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.09.23.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators
import Reminders_Domain

@main
struct RemindersMacOSApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var selectedTab: ObservableString = ObservableString("")
    @StateObject var searchGitHubUser: ObservableString = ObservableString("")
    
    var body: some Scene {
        Window("app-name", id: "main") {
            MainTabCoordinatorView(
                store: ComposableArchitecture.Store(initialState: .initialState) {
                    MainTabCoordinator()
                }
            )
            .onAppear {
                NSWindow.allowsAutomaticWindowTabbing = false
            }
            .environmentObject(selectedTab)
            .environmentObject(searchGitHubUser)
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button {
                    appDelegate.showAboutPanel()
                } label: {
                    Text("navigation.about")
                }
            }
        }
    }
}
