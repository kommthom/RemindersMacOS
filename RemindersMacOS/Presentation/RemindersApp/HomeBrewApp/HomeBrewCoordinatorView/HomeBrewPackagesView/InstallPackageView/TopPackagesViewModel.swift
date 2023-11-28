//
//  TopPackagesViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 30.10.23.
//

import Foundation
import Reminders_Domain

class TopPackagesViewModel: ObservableObject {
    
    // MARK: - Observable Properties -
    
    @Published var topPackages: Loadable<[TopPackage]> = .notRequested
    
    func load(numberOfDays: Int) {
    }
}
