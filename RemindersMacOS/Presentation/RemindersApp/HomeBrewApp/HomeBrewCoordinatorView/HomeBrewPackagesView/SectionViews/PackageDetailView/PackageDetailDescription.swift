//
//  PackageDetailDescription.swift
//  RemindersMacOS
//
//  Created by Thomas on 14.10.23.
//

import SwiftUI

struct PackageDetailDescription: View {
    let description: String
    let packageName: String
    
    var body: some View {
        if !description.isEmpty {
            Text(description)
                .font(.subheadline)
        } else {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.yellow)
                Text("package-details.description-none-\(packageName)")
                    .font(.subheadline)
            }
        }
    }
}

/*#Preview {
    PackageDetailDescription()
}*/
