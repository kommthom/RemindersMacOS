//
//  GetTapsOfFolder.swift
//  RemindersMacOS
//
//  Created by Thomas on 17.10.23.
//

import Foundation
import Reminders_Domain

//@MainActor
func getTapsOfFolder(packageType: PackageType) -> [BrewTap]
{
    var tapsOfFolder: [BrewTap] = .init()
    //FileManagerService.shared.semaphoreWait()
    let targetFolder = getTargetFolder(packageType: packageType)
    do {
        //let contentsOfTapFolder: [URL] = FileManagerService.shared.contentsOfDirectory(packageType: packageType, appendingPathComponent: "", includingPropertiesForKeys: nil , options: .skipsHiddenFiles)
        let contentsOfTapFolder: [URL] = try FileManager.default.contentsOfDirectory(at: targetFolder, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        AppLogger.homeBrew.log("Taps found: \(contentsOfTapFolder.count)")
        for tapRepoParentURL in contentsOfTapFolder {
            //let contentsOfTapRepoParent: [URL] = FileManagerService.shared.contentsOfDirectory(packageType: packageType, appendingPathComponent: tapRepoParentURL.lastPathComponent, includingPropertiesForKeys: nil , options: .skipsHiddenFiles)
            let contentsOfTapRepoParent: [URL] = try FileManager.default.contentsOfDirectory(at: tapRepoParentURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for repoURL in contentsOfTapRepoParent {
                if let fullTapName = getTapNameFromURL(url: repoURL) {
                    tapsOfFolder.append(BrewTap(name: fullTapName))
                }
            }
            AppLogger.homeBrew.log("Found Taps: \(tapsOfFolder.map() {$0.name} .joined(separator: ", "))")
        }
    } catch {
        AppLogger.homeBrew.log(level: .error, "getTapsOfFolder error: \(error.localizedDescription)")
    }
    //FileManagerService.shared.semaphoreSignal()
    return tapsOfFolder
}

private func getTapNameFromURL(url: URL) -> String? {
    let repoParentComponents: [String] = url.pathComponents
    let penultimate = repoParentComponents.count - 2
    if penultimate >= 0 {
        return "\(repoParentComponents[penultimate])/\(String(repoParentComponents.last!.dropFirst(9)))"
    } else {
        return nil
    }
}
