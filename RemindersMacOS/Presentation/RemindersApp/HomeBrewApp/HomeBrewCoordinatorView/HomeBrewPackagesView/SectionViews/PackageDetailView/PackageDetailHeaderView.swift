//
//  PackageDetailHeaderView.swift
//  RemindersMacOS
//
//  Created by Thomas on 14.10.23.
//

import SwiftUI

struct PackageDetailHeaderView: View {
    let packageName: String?
    let versions: [String]?
    let pinned: Bool
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 5) {
            Text(packageName ?? "Package")
                .font(.title)
            Text("v. \(versions?.joined(separator: ", ") ?? "")")
                .font(.subheadline)
                .foregroundColor(.secondary)
            if pinned {
                Image(systemName: "pin.fill")
                    .help("package-details.pinned.help-\(packageName ?? "Package")")
            }
        }
    }
}

/*#Preview {
    PackageDetailHeaderView()
}*/
