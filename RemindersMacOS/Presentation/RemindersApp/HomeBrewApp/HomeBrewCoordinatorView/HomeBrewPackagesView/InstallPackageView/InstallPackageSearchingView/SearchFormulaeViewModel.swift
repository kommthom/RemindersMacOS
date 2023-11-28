//
//  SearchFormulaeViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 30.10.23.
//

import Foundation
import Reminders_Domain

class SearchFormulaeViewModel: SearchResultsViewModel {
    
    override init(getSearchedPackagesUseCase: GetSearchedPackagesUCProtocol) {
        super.init(getSearchedPackagesUseCase: getSearchedPackagesUseCase
        )
        self.isCask = false
    }
    
    override func load(searchText: String) {
        getSearchedPackagesUseCase
            .execute(packageName: searchText, isCask: isCask, searchPackages: loadableSubject(\.foundPackages))
    }
}
