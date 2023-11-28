//
//  MaintenanceFinishedView.swift
//  RemindersMacOS
//
//  Created by Thomas on 25.10.23.
//

import SwiftUI
import ComposableArchitecture

struct MaintenanceFinishedView: View {
    let store: StoreOf<MaintenanceFinished>
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "checkmark.seal")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.secondary)
                /*VStack(alignment: .center)  {
                    VStack(alignment: .leading, spacing: 5)  {
                        Text("maintenance.finished")
                            .font(.headline)
                        if viewStore.state.maintenanceResultStates.shouldUninstallOrphans {
                            Text("maintenance.results.orphans-count-\(viewStore.state.maintenanceResultStates.numberOfOrphansRemoved)")
                        }
                        if viewStore.state.maintenanceResultStates.shouldPurgeCache {
                            VStack(alignment: .leading) {
                                Text("maintenance.results.package-cache")
                                Text("maintenance.results.package-cache.skipped-\(viewStore.state.maintenanceResultStates.packagesHoldingBackCachePurge.formatted(.list(type: .and)))")
                                    .font(.caption)
                                    .foregroundColor(Color(nsColor: NSColor.systemGray))
                            }
                        }
                        if viewStore.state.maintenanceResultStates.shouldDeleteDownloads {
                            VStack(alignment: .leading) {
                                Text("maintenance.results.cached-downloads")
                                Text("maintenance.results.cached-downloads.summary-\(viewStore.state.maintenanceResultStates.reclaimedSpaceAfterCachePurge.formatted(.byteCount(style: .file)))")
                                    .font(.caption)
                                    .foregroundColor(Color(nsColor: NSColor.systemGray))
                            }
                        }
                        if viewStore.state.maintenanceResultStates.shouldPerformHealthCheck {
                            if viewStore.state.maintenanceResultStates.brewHealthCheckFoundNoProblems {
                                Text("maintenance.results.health-check.problems-none")
                            } else {
                                Text("maintenance.results.health-check.problems")
                            }
                        }
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            viewStore.send(.goBackToRoot)
                        } label: {
                            Text("action.close")
                        }
                        .keyboardShortcut(.defaultAction)
                    }
                }
                .fixedSize()*/
            }
            .padding()
        }
    }
}

/*#Preview {
    MaintenanceFinishedView()
}*/
