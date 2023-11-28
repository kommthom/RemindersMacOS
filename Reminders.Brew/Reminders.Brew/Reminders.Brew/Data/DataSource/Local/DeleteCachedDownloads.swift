//
//  DeleteCachedDownloads.swift
//  Reminders.Brew
//
//  Created by Thomas on 17.11.23.
//

import Foundation
import Reminders_Domain

public func deleteCachedDownloads() -> Int {
    AppLogger.homeBrew.log("Call to deleteCachedDownloads()")
    do {
        for url in try FileManager.default.contentsOfDirectory(at: HomeBrewConstants.brewCachedFormulaeDownloadsPath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
            if try url.resourceValues(forKeys: [.isSymbolicLinkKey]).isSymbolicLink  ?? false {
                try? FileManager.default.removeItem(at: url)
            }
        }
    } catch  let error as NSError {
        AppLogger.homeBrew.log(level: .error, error.localizedDescription)
    }
    do {
        for url in try FileManager.default.contentsOfDirectory(at: HomeBrewConstants.brewCachedCasksDownloadsPath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
            if try url.resourceValues(forKeys: [.isSymbolicLinkKey]).isSymbolicLink  ?? false {
                try? FileManager.default.removeItem(at: url)
            }
        }
    } catch  let error as NSError {
        AppLogger.homeBrew.log(level: .error, error.localizedDescription)
    }
    do {
        for url in try FileManager.default.contentsOfDirectory(at: HomeBrewConstants.brewCachedDownloadsPath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
            if try !(url.resourceValues(forKeys: [.isSymbolicLinkKey]).isSymbolicLink  ?? false) {
                try? FileManager.default.removeItem(at: url)
            }
        }
    } catch  let error as NSError {
        AppLogger.homeBrew.log(level: .error, error.localizedDescription)
    }
    return Int(directorySize(url: HomeBrewConstants.brewCachedDownloadsPath))
}
