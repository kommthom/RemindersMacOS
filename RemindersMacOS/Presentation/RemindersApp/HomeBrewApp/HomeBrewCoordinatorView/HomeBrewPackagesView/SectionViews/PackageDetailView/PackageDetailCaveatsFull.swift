//
//  PackageDetailCaveatsFull.swift
//  RemindersMacOS
//
//  Created by Thomas on 14.10.23.
//

import SwiftUI
import Reminders_Domain

struct PackageDetailCaveatsFull: View {
    let caveats: String
    let caveatDisplayOptions: PackageCaveatDisplay
    @State private var isShowingExpandedCaveats: Bool = false
    @State private var canExpandCaveats: Bool = false
    
    var body: some View {
        if !caveats.isEmpty {
            if caveatDisplayOptions == .full {
                GroupBox {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.yellow)
                        /// Remove the last newline from the text if there is one, and replace all double newlines with a single newline
                        VStack(alignment: .leading, spacing: 5) {
                            let text = Text(.init(caveats.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\n\n", with: "\n")))
                                .lineSpacing(5)
                                .textSelection(.enabled)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .lineLimit(isShowingExpandedCaveats ? nil : 2)
                            text.background {
                                    ViewThatFits(in: .vertical) {
                                        text.hidden()
                                        Color.clear.onAppear { canExpandCaveats = true }
                                    }
                                }
                            if canExpandCaveats {
                                Button {
                                    withAnimation {
                                        isShowingExpandedCaveats.toggle()
                                    }
                                } label: {
                                    Text(isShowingExpandedCaveats ? "package-details.caveats.collapse" : "package-details.caveats.expand")
                                }
                                .padding(.top, 5)
                            }
                        }
                    }
                    .padding(2)
                }
            }
        }
    }
}

/*#Preview {
    PackageDetailCaveatsFull()
}*/
