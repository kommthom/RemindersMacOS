//
//  MaintenanceView.swift
//  RemindersMacOS
//
//  Created by Thomas on 11.10.23.
//

import SwiftUI
import ComposableArchitecture

struct MaintenanceView: View {
    let store: StoreOf<Maintenance>
    //@State var fastCacheDeletion: Bool
    //@StateObject var viewModel: MaintenanceViewModel
    @State var shouldUninstallOrphans: Bool = true
    @State var shouldPurgeCache: Bool = true
    @State var shouldDeleteDownloads: Bool = true
    @State var shouldPerformHealthCheck: Bool = false
    
    init(store: StoreOf<Maintenance>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    Text("maintenance.title")
                        .font(.headline)
                    VStack(alignment: .leading, spacing: 10) {
                        Form {
                            LabeledContent("maintenance.steps.packages") {
                                VStack(alignment: .leading) {
                                    Toggle(isOn: $shouldUninstallOrphans) {
                                        Text("maintenance.steps.packages.uninstall-orphans")
                                    }
                                }
                            }
                            LabeledContent("maintenance.steps.downloads") {
                                VStack(alignment: .leading) {
                                    Toggle(isOn: $shouldPurgeCache) {
                                        Text("maintenance.steps.downloads.purge-cache")
                                    }
                                    Toggle(isOn: $shouldDeleteDownloads) {
                                        Text("maintenance.steps.downloads.delete-cached-downloads")
                                    }
                                }
                            }
                            LabeledContent("maintenance.steps.other") {
                                Toggle(isOn: $shouldPerformHealthCheck) {
                                    Text("maintenance.steps.other.health-check")
                                }
                            }
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
                                viewStore.send(.maintenanceRunningButtonTapped(shouldUninstallOrphans, shouldPurgeCache, shouldDeleteDownloads, shouldPerformHealthCheck))
                            } label: {
                                Text("maintenance.steps.start")
                            }
                            .keyboardShortcut(.defaultAction)
                            .disabled([shouldUninstallOrphans, shouldPurgeCache, shouldDeleteDownloads, shouldPerformHealthCheck].allSatisfy { !$0 })
                        }
                    }
                }
            }
            .frame(minWidth: 300)
            .onAppear(perform: {
                if viewStore.state.fastCacheDeletion {
                    shouldUninstallOrphans = false
                    shouldPurgeCache = false
                    shouldDeleteDownloads = false
                }
            })
        }
    }
}

/*#Preview {
    MaintenanceView()
}*/
