//
//  PackageDetailProtocols.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.11.23.
//

import Foundation
import Reminders_Domain

protocol PackageDetailInteractorProtocol {
    func loadPackageInfo(packageName: String, isCask: Bool, homeBrewPackageInfo: LoadableSubject<BrewPackageInfo>) -> Void
    func pinAndUnpinPackage(packageName: String, pinned: Bool, success: ExecutableSubject<Bool>) -> Void
}

protocol PackageDetailViewModelProtocol {
    var state: PackageDetailViewModelState { get set }
    var brewPackageName: String { get }
    var versions: [String] { get }
    var installedOn: Date? { get }
    var sizeInBytes: Int64? { get }
    var isCask: Bool { get }
    func loadPackageInfo() -> Void
    func pinAndUnpinPackage() -> Void
}
