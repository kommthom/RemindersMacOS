//
//  AboutView.swift
//  RemindersMacOS
//
//  Created by Thomas on 12.10.23.
//

import SwiftUI
import Reminders_Domain

struct AboutView: View
{
    @State private var usedPackages: [UsedPackage] = [
        UsedPackage(
            name: "about.packages.1.name",
            whyIsItUsed: "about.packages.1.purpose",
            packageURL: URL(string: "https://github.com/buresdv/DavidFoundation")!
        ),
        UsedPackage(
            name: "about.packages.2.name",
            whyIsItUsed: "about.packages.2.purpose",
            packageURL: URL(string: "https://github.com/SwiftyJSON/SwiftyJSON")!
        )
    ]

    @State private var specialThanks: [AcknowledgedContributor] = [
        AcknowledgedContributor(
            name: "about.thanks.1.name",
            reasonForAcknowledgement: "about.thanks.1.purpose",
            profileService: .github,
            profileURL: URL(string: "https://github.com/sebj")!)
        ,
    ]
    @State private var acknowledgedContributors: [AcknowledgedContributor] = [
        AcknowledgedContributor(
            name: "about.contributors.5.name",
            reasonForAcknowledgement: "about.contributors.5.purpose",
            profileService: .website,
            profileURL: URL(string: "https://andreyrd.com")!
        ),
    ]

    @State private var isPackageGroupExpanded: Bool = false
    @State private var isContributorGroupExpanded: Bool = false
    @State private var isTranslatorGroupExpanded: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(nsImage: NSImage(named: "AppIcon") ?? NSImage())
                .resizable()
                .frame(width: 150, height: 150)
                .transaction { $0.animation = nil }
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text(Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "")
                        .font(.title)
                    Text("about.version-\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")-\(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "")")
                        .font(.caption)
                }
                Text("about.copyright")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                VStack {
                    DisclosureGroup(isExpanded: $isPackageGroupExpanded) {
                        List($usedPackages) { package in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(package.wrappedValue.name)
                                        .font(.headline)
                                    Text(package.wrappedValue.whyIsItUsed)
                                        .font(.subheadline)
                                }
                                Spacer()
                                Link("GitHub", destination: package.wrappedValue.packageURL)
                            }
                        }
                        .listStyle(.bordered(alternatesRowBackgrounds: true))
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            idealHeight: 100
                        )
                    } label: {
                        Text("about.packages")
                    }
                    .animation(.none, value: isPackageGroupExpanded)
                    DisclosureGroup {
                        List {
                            Section("about.thanks") {
                                ForEach(specialThanks) { contributor in
                                    HStack(spacing: 10) {
                                        VStack(alignment: .leading) {
                                            Text(contributor.name)
                                                .font(.headline)
                                            Text(contributor.reasonForAcknowledgement)
                                                .font(.subheadline)
                                        }
                                        Spacer()
                                        Link(contributor.profileService.key, destination: contributor.profileURL)
                                    }
                                }
                            }
                            Section("about.contributors") {
                                ForEach(acknowledgedContributors) { contributor in
                                    HStack(spacing: 10) {
                                        VStack(alignment: .leading) {
                                            Text(contributor.name)
                                                .font(.headline)
                                            Text(contributor.reasonForAcknowledgement)
                                                .font(.subheadline)
                                        }
                                        Spacer()
                                        Link(contributor.profileService.key, destination: contributor.profileURL)
                                    }
                                }
                            }
                        }
                        .listStyle(.bordered(alternatesRowBackgrounds: true))
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            idealHeight: 200
                        )
                    } label: {
                        Text("about.contributors")
                    }
                    .animation(.none, value: isContributorGroupExpanded)
                }
                HStack {
                    Button {
                        NSWorkspace.shared.open(URL(string: "https://github.com/buresdv/Cork")!)
                    } label: {
                        Label("about.contribute", systemImage: "curlybraces")
                    }
                    Spacer()
                    Button {
                        NSWorkspace.shared.open(URL(string: "https://elk.zone/mstdn.social/@davidbures")!)
                    } label: {
                        Label("about.contact", systemImage: "paperplane")
                    }
                }
            }
            .frame(width: 350, alignment: .topLeading)
            .transaction { $0.animation = nil }
        }
        .padding()
    }
}


#Preview {
    AboutView()
}
