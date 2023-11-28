//
//  LoadingView.swift
//  RemindersMacOS
//
//  Created by Thomas on 11.10.23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack {
            ProgressView()
                .scaleEffect(0.5)
            Text("loadingview.text")
        }
        .foregroundColor(.secondary)
    }
}

#Preview {
    LoadingView()
}
