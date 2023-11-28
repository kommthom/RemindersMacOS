//
//  MainTabCoordinatorView.swift
//  RemindersMacOS
//
//  Created by Thomas on 02.10.23.
//

import SwiftUI
import ComposableArchitecture
import Reminders_Domain

struct MainTabCoordinatorView: View {
    let store: StoreOf<MainTabCoordinator>
    public static let needsNewSize = Notification.Name("needsNewSize")
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @EnvironmentObject var selectedTab: ObservableString
    @StateObject var gitHubFilterCriteria: GitHubFilterCriteria = GitHubFilterCriteria(language: "swift", titleContains: "mvvm")
    @StateObject var isGitHubAuthenticated: ObservableBool = ObservableBool()
    @StateObject var topPackages = TopPackagesTracker()
    @StateObject var homeBrewMainVM: HomeBrewMainViewModel = DIContainer.shared.resolve()
    @StateObject var myListsMainVM: MyListsViewModel = DIContainer.shared.resolve()
    
    var body: some View {
        WithViewStore(store, observe: \.selectedTab) { viewStore in
            if selectedTab.value == "gitHub" {
                let _ = viewStore.send(MainTabCoordinator.Action.tabSelected(MainTabCoordinator.Tab.gitHub))
            } else if selectedTab.value == "homeBrew" {
                let _ = viewStore.send(MainTabCoordinator.Action.tabSelected(MainTabCoordinator.Tab.homeBrew))
            } else if selectedTab.value == "app" {
                let _ = viewStore.send(MainTabCoordinator.Action.tabSelected(MainTabCoordinator.Tab.app))
            }
            if selectedTab.value != "" {
                let _ = Delay(1).performWork {
                    selectedTab.value = ""
                }
            }
            //NavigationView {
                TabView(selection: viewStore.binding(get: { $0 }, send: MainTabCoordinator.Action.tabSelected)) {
                    MyListsAppCoordinatorView(
                        store: store.scope(
                            state: { $0.app },
                            action: { .app($0) }
                        )
                    )
                    .tabItem { Text("app-section.main") }
                    .tag(MainTabCoordinator.Tab.app)
                    .environmentObject(appDelegate.remindersState)
                    .environmentObject(myListsMainVM)
                    .onAppear(perform: {
                        NotificationCenter.default.post(name: MainTabCoordinatorView.needsNewSize, object: CGSize(width: Geometries.main.window[AppSection.reminders.rawValue].width, height: Geometries.main.window[AppSection.reminders.rawValue].height))
                    })
                    .frame(minWidth: Geometries.main.content[AppSection.reminders.rawValue].width, maxWidth: .infinity, minHeight: Geometries.main.content[AppSection.reminders.rawValue].height, maxHeight: .infinity)
                    
                    GitHubCoordinatorView(
                        store: store.scope(
                            state: { $0.gitHub },
                            action: { .gitHub($0) }
                        )
                    )
                    .tabItem { Text("app-section.github") }
                    .tag(MainTabCoordinator.Tab.gitHub)
                    .environmentObject(appDelegate.gitHubState)
                    .environmentObject(gitHubFilterCriteria)
                    .environmentObject(isGitHubAuthenticated)
                    .onAppear(perform: {
                        NotificationCenter.default.post(name: MainTabCoordinatorView.needsNewSize, object: CGSize(width: Geometries.main.window[AppSection.reminders.rawValue].width, height: Geometries.main.window[AppSection.reminders.rawValue].height))
                    })
                    .frame(minWidth: Geometries.main.content[AppSection.gitHub.rawValue].width, maxWidth: .infinity, minHeight: Geometries.main.window[AppSection.gitHub.rawValue].height, maxHeight: .infinity)
                    
                    HomeBrewCoordinatorView(
                        store: store.scope(
                            state: { $0.homeBrew },
                            action: { .homeBrew($0) }
                        )
                    )
                    .tabItem { Text("app-section.homebrew") }
                    .tag(MainTabCoordinator.Tab.homeBrew)
                    .environmentObject(homeBrewMainVM)
                    .environmentObject(appDelegate.homeBrewState)
                    .environmentObject(topPackages)
                    .onAppear(perform: {
                        NotificationCenter.default.post(name: MainTabCoordinatorView.needsNewSize, object: CGSize(width: Geometries.main.window[AppSection.homeBrew.rawValue].width, height: Geometries.main.window[AppSection.homeBrew.rawValue].height))
                    })
                    .frame(minWidth: Geometries.main.content[AppSection.homeBrew.rawValue].width, maxWidth: .infinity, minHeight: Geometries.main.window[AppSection.homeBrew.rawValue].height, maxHeight: .infinity)
                }
            //}
        }
    }
}


#Preview {
    MainTabCoordinatorView(store: ComposableArchitecture.Store(initialState: .initialState) {
        MainTabCoordinator()
        }
    )
}
