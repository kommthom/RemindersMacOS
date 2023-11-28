//
//  TapDetailsIncludedPackagesDetailView.swift
//  RemindersMacOS
//
//  Created by Thomas on 20.10.23.
//

import SwiftUI

struct TapDetailsIncludedPackagesDetailView: View {
    @State private var isShowingIncludedFormulae: Bool = false
    @State private var isShowingIncludedCasks: Bool = false
    
    let includedFormulae: [String]?
    let includedCasks: [String]?
    let installedFormulae: [String]
    let installedCasks: [String]
    
    var body: some View {
        GroupBox {
            VStack {
                if let _ = includedFormulae {
                    DisclosureGroup("tap-details.included-formulae", isExpanded: $isShowingIncludedFormulae) {}
                    .disclosureGroupStyle(NoPadding())
                    if isShowingIncludedFormulae {
                        PackagesIncludedInTapList(packages: includedFormulae!, installedFormulae: installedFormulae, installedCasks: installedCasks)
                    }
                }
                if includedFormulae != nil && includedCasks != nil {
                    Divider()
                }
                if let _ = includedCasks {
                    DisclosureGroup("tap-details.included-casks", isExpanded: $isShowingIncludedCasks) {}
                        .disclosureGroupStyle(NoPadding())
                    if isShowingIncludedCasks {
                        PackagesIncludedInTapList(packages: includedCasks!, installedFormulae: installedFormulae, installedCasks: installedCasks)
                    }
                }
            }
        }
    }
}

/*#Preview {
    TapDetailsIncludedPackagesDetailView()
}*/
