//
//  AnalyticsStatusView.swift
//  RemindersMacOS
//
//  Created by Thomas on 22.10.23.
//

import SwiftUI

struct AnalyticsStatusView: View {
    @AppStorage("allowBrewAnalytics") var allowBrewAnalytics: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 15) {
                Image(systemName: "chart.bar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                VStack(alignment: .leading, spacing: 2) {
                    Text(allowBrewAnalytics ? "start-page.analytics.enabled" : "start-page.analytics.disabled")
                    Text(allowBrewAnalytics ? "start-page.analytics.enabled.description" : "start-page.analytics.disabled.description")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(2)
        }
    }
}

#Preview {
    AnalyticsStatusView()
}
