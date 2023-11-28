//
//  InstallPackageRunningViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 31.10.23.
//

import Foundation
import Reminders_Domain

class InstallPackageRunningViewModel: ObservableObject {
    
    var getSearchedPackagesUseCase: GetSearchedPackagesUCProtocol
    var isCask: Bool = false
    
    init(getSearchedPackagesUseCase: GetSearchedPackagesUCProtocol) {
        self.getSearchedPackagesUseCase = getSearchedPackagesUseCase
    }
    
    // MARK: - Observable Properties -
    
    @Published var foundPackages: Loadable<[String]> = .notRequested
    
    func load(searchText: String) {
    }

}
