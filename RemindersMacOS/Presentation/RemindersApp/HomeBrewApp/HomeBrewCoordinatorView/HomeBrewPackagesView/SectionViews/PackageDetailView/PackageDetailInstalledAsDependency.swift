//
//  PackageDetailInstalledAsDependency.swift
//  RemindersMacOS
//
//  Created by Thomas on 14.10.23.
//

import SwiftUI

struct PackageDetailInstalledAsDependency: View {
    var packageDependents: [String]?
    var body: some View {
        if let _ = packageDependents {
            if packageDependents!.count != 0 { // This happens when the package was originally installed as a dependency, but the parent is no longer installed
                Text("package-details.dependants.dependency-of-\(packageDependents!.joined(separator: ", "))")
                    .font(.caption2)
                    .padding(.horizontal, 4)
                    .foregroundColor(.secondary)
                    .overlay(Capsule().stroke(.secondary, lineWidth: 1))
            }
        } else {
            HStack(alignment: .center, spacing: 5) {
                ProgressView()
                    .scaleEffect(0.3, anchor: .center)
                    .frame(width: 5, height: 5)
                Text("package-details.dependants.loading")
            }
            .font(.caption2)
            .padding(.horizontal, 4)
            .foregroundColor(Color(.tertiaryLabelColor))
            .overlay(Capsule().stroke(Color(.tertiaryLabelColor), lineWidth: 1))
        }
    }
}

/*#Preview {
    PackageDetailInstalledAsDependency()
}*/
