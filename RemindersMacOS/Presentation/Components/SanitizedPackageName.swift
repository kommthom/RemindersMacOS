//
//  SanitizedPackageName.swift
//  RemindersMacOS
//
//  Created by Thomas on 23.10.23.
//

import SwiftUI
import Reminders_Domain

/// Package name that contains only the name of the package, not its version in the `package@version` format
struct SanitizedPackageName: View {
    let packageName: String
    @State var shouldShowVersion: Bool

    var body: some View {
        if packageName.contains("@") { /// Only do the matching if the name contains @
            if let sanitizedName = try? regexMatch(from: packageName, regex: ".+?(?=@)") { /// Try to REGEX-match the name out of the raw name
                HStack(alignment: .firstTextBaseline, spacing: 5) {
                    Text(sanitizedName)
                    if shouldShowVersion {
                        /// The version is the lenght of the package name, + 1 due to the @ character
                        Text("v. \(String(packageName.dropFirst(sanitizedName.count + 1)))")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                }
            } else { /// If the REGEX matching fails, just show the entire name
                Text(packageName)
            }
        } else { /// If the name doesn't contain the @, don't do anything
            Text(packageName)
        }
    }
}
