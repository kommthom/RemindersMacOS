//
//  PackageDetailInstalledOn.swift
//  RemindersMacOS
//
//  Created by Thomas on 14.10.23.
//

import SwiftUI
import Reminders_Domain

struct PackageDetailInstalledOn: View {
    let installedOnDate: Date
    let sizeInBytes: Int64?
    let isCask: Bool
    @State private var isShowingPopover: Bool = false
    
    var body: some View {
        GroupBox {
            Grid(alignment: .leading, horizontalSpacing: 20) {
                GridRow(alignment: .top) {
                    Text("package-details.install-date")
                    Text(installedOnDate.formatted(.packageInstallationStyle))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                if let packageSize = sizeInBytes {
                    Divider()
                    GridRow(alignment: .top)
                    {
                        Text("package-details.size")
                        HStack {
                            Text(packageSize.formatted(.byteCount(style: .file)))
                            if isCask {
                                HelpButton {
                                    isShowingPopover.toggle()
                                }
                                .help("package-details.size.help")
                                .popover(isPresented: $isShowingPopover) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("package-details.size.help.title")
                                            .font(.headline)
                                        Text("package-details.size.help.body-1")
                                        Text("package-details.size.help.body-2")
                                    }
                                    .padding()
                                    .frame(width: 300, alignment: .center)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

/*#Preview {
    PackageDetailInstalledOn()
}*/
