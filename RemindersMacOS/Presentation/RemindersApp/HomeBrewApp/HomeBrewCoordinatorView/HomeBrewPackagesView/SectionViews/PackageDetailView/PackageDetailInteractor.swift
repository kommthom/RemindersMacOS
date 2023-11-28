//
//  PackageDetailInteractor.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.11.23.
//

import Foundation
import Reminders_Domain

final class PackageDetailInteractor: PackageDetailInteractorProtocol {
    
    // MARK: Use Cases
    
    private var getBrewPackageInfoUseCase: GetBrewPackageInfoUCProtocol
    private var pinAndUnpinPackageUseCase: PinAndUnpinPackageUCProtocol
    
    init(getBrewPackageInfoUseCase: GetBrewPackageInfoUCProtocol, pinAndUnpinPackageUseCase: PinAndUnpinPackageUCProtocol) {
        self.getBrewPackageInfoUseCase = getBrewPackageInfoUseCase
        self.pinAndUnpinPackageUseCase = pinAndUnpinPackageUseCase
    }
    
    func loadPackageInfo(packageName: String, isCask: Bool, homeBrewPackageInfo: LoadableSubject<BrewPackageInfo>) {
        getBrewPackageInfoUseCase
            .execute( packageName: packageName, isCask: isCask, homeBrewPackageInfo: homeBrewPackageInfo)
    }
    
    func pinAndUnpinPackage(packageName: String, pinned: Bool, success: ExecutableSubject<Bool>) -> Void {
        pinAndUnpinPackageUseCase
            .execute(packageName: packageName, pinned: pinned, success: success)
    }
}
