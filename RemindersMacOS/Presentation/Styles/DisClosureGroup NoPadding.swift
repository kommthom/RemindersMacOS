//
//  DisClosureGroup NoPadding.swift
//  RemindersMacOS
//
//  Created by Thomas on 14.10.23.
//

import SwiftUI

struct NoPadding: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            withAnimation {
                configuration.isExpanded.toggle()
            }
        } label: {
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: configuration.isExpanded ? "chevron.down" : "chevron.right")
                    .scaleEffect(0.8)
                    .foregroundColor(.secondary)
                    .symbolVariant(.fill)
                configuration.label
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        if configuration.isExpanded {
            configuration.content
        }
    }
}
