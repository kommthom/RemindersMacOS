//
//  PackageDetailTapTypeHomepage.swift
//  RemindersMacOS
//
//  Created by Thomas on 14.10.23.
//

import SwiftUI

struct PackageDetailTapTypeHomepage: View {
    let tap: String
    let isCask: Bool
    let homepage: URL
    
    var body: some View {
        GroupBox
        {
            Grid(alignment: .leading, horizontalSpacing: 20) {
                GridRow(alignment: .firstTextBaseline) {
                    Text("packagedetail.text.tap")
                    Text(tap)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Divider()
                GridRow(alignment: .top) {
                    Text("package-details.type")
                    isCask ? Text("package-details.type.cask") : Text("package-details.type.formula")
                }
                Divider()
                GridRow(alignment: .top) {
                    Text("package-details.homepage")
                    Link(destination: homepage) {
                        Text(homepage.absoluteString)
                    }
                }
            }
        }
    }
}

/*#Preview {
    PackageDetailTapTypeHomepage()
}*/
