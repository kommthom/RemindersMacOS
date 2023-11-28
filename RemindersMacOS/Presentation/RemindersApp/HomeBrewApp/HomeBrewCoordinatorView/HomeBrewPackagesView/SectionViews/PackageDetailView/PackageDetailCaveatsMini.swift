//
//  PackageDetailCaveats.swift
//  RemindersMacOS
//
//  Created by Thomas on 14.10.23.
//

import SwiftUI
import Reminders_Domain

struct PackageDetailCaveatsMini: View {
    let caveats: String
    let caveatDisplayOptions: PackageCaveatDisplay
    @State private var isShowingCaveatPopover: Bool = false
    
    var body: some View {
        if !caveats.isEmpty {
            if caveatDisplayOptions == .mini {
                Text("package-details.caveats.available")
                    .font(.caption2)
                    .padding(.horizontal, 4)
                    .foregroundColor(.indigo)
                    .overlay(Capsule().stroke(.indigo, lineWidth: 1))
                    .onTapGesture {
                        isShowingCaveatPopover.toggle()
                    }
                    .popover(isPresented: $isShowingCaveatPopover){
                        Text(.init(caveats.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\n\n", with: "\n")))
                            .textSelection(.enabled)
                            .lineSpacing(5)
                            .padding()
                            .help("package-details.caveats.help")
                    }
            }
        }
    }
}

/*#Preview {
    PackageDetailCaveats()
}*/
