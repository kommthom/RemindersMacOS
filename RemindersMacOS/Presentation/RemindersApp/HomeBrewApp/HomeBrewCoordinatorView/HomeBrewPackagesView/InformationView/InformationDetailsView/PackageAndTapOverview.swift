//
//  PackageAndTapOverview.swift
//  RemindersMacOS
//
//  Created by Thomas on 22.10.23.
//

import SwiftUI

struct PackageAndTapOverview: View {
    let formulaeCount: Int
    let casksCount: Int
    let tapsCount: Int
    var body: some View {
        VStack(alignment: .leading) {
            GroupBoxHeadlineGroup(
                image: "terminal",
                title: LocalizedStringKey("start-page.installed-formulae.count-\(formulaeCount)"),
                mainText: "start-page.installed-formulae.description"
            )
            Divider()
            GroupBoxHeadlineGroup(
                image: "macwindow",
                title: LocalizedStringKey("start-page.installed-casks.count-\(casksCount)"),
                mainText: "start-page.installed-casks.description"
            )
            Divider()
            GroupBoxHeadlineGroup(
                image: "spigot",
                title: LocalizedStringKey("start-page.added-taps.count-\(tapsCount)"),
                mainText: "start-page.added-taps.description"
            )
        }
    }
}

struct GroupBoxHeadlineGroup: View {
    var image: String
    let title: LocalizedStringKey
    let mainText: LocalizedStringKey

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .contentTransition(.numericText())
                Text(mainText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(2)
    }
}

#Preview {
    PackageAndTapOverview(formulaeCount: 1, casksCount: 2, tapsCount: 3)
}
