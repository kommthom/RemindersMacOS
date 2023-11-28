//
//  TapDetailIncludedPackagesView.swift
//  RemindersMacOS
//
//  Created by Thomas on 20.10.23.
//

import SwiftUI

struct TapDetailIncludedPackagesView: View {
    let includedFormulae: [String]?
    let includedCasks: [String]?
    let homePage: URL
    
    var body: some View {
        GroupBox {
            Grid(alignment: .leading, horizontalSpacing: 20) {
                GridRow(alignment: .firstTextBaseline) {
                    Text("tap-details.contents")
                    if includedFormulae == nil && includedCasks == nil {
                        Text("tap-details.contents.none")
                    } else if includedFormulae != nil && includedCasks == nil {
                        Text("tap-details.contents.formulae-only")
                    } else if includedCasks != nil && includedFormulae == nil {
                        Text("tap-details.contents.casks-only")
                    } else if includedFormulae?.count ?? 0 > includedCasks?.count ?? 0 {
                        Text("tap-details.contents.formulae-mostly")
                    } else if includedFormulae?.count ?? 0 < includedCasks?.count ?? 0 {
                        Text("tap-details.contents.casks-mostly")
                    }
                }
                Divider()
                GridRow(alignment: .firstTextBaseline) {
                    Text("tap-details.package-count")
                    Text(((includedFormulae?.count ?? 0) + (includedCasks?.count ?? 0)).formatted())
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Divider()
                GridRow(alignment: .firstTextBaseline) {
                    Text("tap-details.homepage")
                    Link(destination: homePage) {
                        Text(homePage.absoluteString)
                    }
                }
            }
        }
    }
}

/*#Preview {
    TapDetailIncludedPackagesView()
}*/
