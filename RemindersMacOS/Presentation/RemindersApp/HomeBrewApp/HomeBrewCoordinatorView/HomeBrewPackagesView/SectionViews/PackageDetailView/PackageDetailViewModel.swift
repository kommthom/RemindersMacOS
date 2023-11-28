//
//  PackageDetailViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 13.10.23.
//

import Foundation
import SwiftUI
import Reminders_Domain

class PackageDetailViewModel: ObservableObject, PackageDetailViewModelProtocol {
    @Published var state: PackageDetailViewModelState
    private let interactor: PackageDetailInteractorProtocol
    private let brewPackage: BrewPackage
    let brewPackageName: String
    let versions: [String]
    let installedOn: Date?
    let sizeInBytes: Int64?
    let isCask: Bool
    
    init(brewPackage: BrewPackage, interactor: PackageDetailInteractorProtocol) {
        self.interactor = interactor
        self.brewPackage = brewPackage
        self.brewPackageName = brewPackage.name
        self.versions = brewPackage.versions
        self.isCask = brewPackage.isCask
        self.installedOn = brewPackage.installedOn
        self.sizeInBytes = brewPackage.sizeInBytes
        self.state = .init()
    }
    
    func loadPackageInfo() -> Void {
        interactor
            .loadPackageInfo(packageName: brewPackageName, isCask: isCask, homeBrewPackageInfo: loadableSubject(\.state.homeBrewPackageInfo))
    }
    
    func pinAndUnpinPackage() -> Void {
        interactor
            .pinAndUnpinPackage(packageName: brewPackageName, pinned: state.pinned ?? false, success: executableSubject(\.state.pinAndUnpinSuccess))
    }
}
