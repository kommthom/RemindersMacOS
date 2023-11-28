//
//  PackagesIncludedInTap.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.10.23.
//

import SwiftUI

struct PackagesIncludedInTapList: View
{
    @State var packages: [String]
    @State private var searchString: String = ""
    let installedFormulae: [String]
    let installedCasks: [String]

    var body: some View {
        VStack(spacing: 5) {
            CustomSearchField(search: $searchString, customPromptText: "tap-details.included-packages.search.prompt")
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(searchString.isEmpty ? packages.enumerated() : packages.filter { $0.contains(searchString) }.enumerated()), id: \.offset) { index, package in
                        HStack(alignment: .center) {
                            Text(package)
                            if installedFormulae.contains(where: { $0 == package }) || installedCasks.contains(where: { $0 == package }) {
                                Text("add-package.result.already-installed")
                                    .font(.caption)
                                    .padding(.horizontal, 4)
                                    .background(Color(nsColor: NSColor.tertiaryLabelColor))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(6)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .background(index % 2 == 0 ? Color(nsColor: NSColor.alternatingContentBackgroundColors[0]) : Color(nsColor: NSColor.alternatingContentBackgroundColors[1]))
                    }
                }
            }
            .frame(maxHeight: 150)
            .border(Color(nsColor: .lightGray))
        }
    }
}


/*#Preview {
    PackagesIncludedInTap()
}*/
