//
//  SearchResultRow.swift
//  RemindersMacOS
//
//  Created by Thomas on 30.10.23.
//

import SwiftUI
import SwiftyJSON
import Reminders_Domain
import Reminders_Brew

struct SearchResultRow: View {
    @AppStorage("showDescriptionsInSearchResults") var showDescriptionsInSearchResults: Bool = true
    @AppStorage("showCompatibilityWarning") var showCompatibilityWarning: Bool = true
    
    @EnvironmentObject var brewData: BrewDataStorage
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    @State var packageName: String
    @State var isCask: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                SanitizedPackageName(packageName: packageName, shouldShowVersion: true)
                if isCask {
                    if brewData.installedCasks.contains(where: { $0.name == packageName }) {
                        LocalizableCaptionText(localizedText: "add-package.result.already-installed")
                    }
                } else {
                    if brewData.installedFormulae.contains(where: { $0.name == packageName }) {
                        LocalizableCaptionText(localizedText: "add-package.result.already-installed")
                    }
                }
                if showCompatibilityWarning {
                    switch viewModel.loadedDescription {
                    case .notRequested:
                        notRequestedPackageDescriptionView
                    case .isLoading(_, _):
                        Text("add-package.result.loading-compatibility")
                    case .loaded(let description):
                        if !description.isCompatible {
                            HStack(alignment: .center, spacing: 4) {
                                Image(systemName: "exclamationmark.circle")
                                Text("add-package.result.not-optimized-for-\(HomeBrewConstants.osVersionString.fullName)")
                            }
                            .font(.subheadline)
                            .foregroundColor(.red)
                        }
                    case .failed(_):
                        Text("add-package.result.loading-failed")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
            if showDescriptionsInSearchResults {
                switch viewModel.loadedDescription {
                case .notRequested:
                    notRequestedPackageDescriptionView
                case .isLoading(_, _):
                    Text("add-package.result.loading-description")
                        .font(.caption)
                        .foregroundColor(.secondary)
                case .loaded(let description):
                    if description.description.isEmpty {
                        Text("add-package.result.description-empty")
                            .font(.caption)
                            .foregroundColor(Color(nsColor: .tertiaryLabelColor))
                    } else {
                        Text(description.description)
                            .font(.caption)
                    }
                case .failed(_):
                    Text("add-package.result.loading-failed")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
    }
    
    var notRequestedPackageDescriptionView: some View {
        Text("").onAppear(perform: { viewModel.load(packageName: packageName, isCask: isCask) })
    }
    
}

struct LocalizableCaptionText: View {
    @State var localizedText: LocalizedStringKey
    @State var color: NSColor = .tertiaryLabelColor
    @State var font: Font = .caption
    
    var body: some View {
        Text(localizedText)
            .font(font)
            .padding(.horizontal, 4)
            .background(Color(color))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

extension SearchResultRow {
    
    class ViewModel: ObservableObject {
        @Inject private var getBrewPackagaDescriptionUseCase: GetBrewPackageDescriptionUCProtocol
        
        @Published var loadedDescription: Loadable<BrewPackageDescription> = .notRequested
        
        func load(packageName: String, isCask: Bool) {
            getBrewPackagaDescriptionUseCase
                .execute(packageName: packageName, isCask: isCask, packageDescription: loadableSubject(\.loadedDescription))
        }
    }
}

/*#Preview {
    SearchResultRow()
}*/
