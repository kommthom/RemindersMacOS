//
//  HomeBrewConstants.swift
//  RemindersMacOS
//
//  Created by Thomas on 12.10.23.
//

import Foundation
import Reminders_Domain

public struct HomeBrewConstants {
    /// **Basic executables and file locations**
    public static let brewExecutableDir: URL = {
        if FileManager.default.fileExists(atPath: "/opt/homebrew/bin/brew") { // Apple Sillicon
            return URL(string: "/opt/homebrew/bin")!
        } else { // Intel
            return URL(string: "/usr/local/bin")!
        }
    }()
    public static let brewExecutableName: String = "brew"
    public static let brewExecutablePath: URL = brewExecutableDir.appendingPathComponent(brewExecutableName)
    public static let brewCellarPath: URL = {
        if FileManager.default.fileExists(atPath: "/opt/homebrew/Cellar") { // Apple Sillicon
            return URL(string: "/opt/homebrew/Cellar")!
        } else { // Intel
            return URL(string: "/usr/local/Cellar")!
        }
    }()
    public static let brewCaskPath: URL = {
        if FileManager.default.fileExists(atPath: "/opt/homebrew/Caskroom") { // Apple Sillicon
            return URL(string: "/opt/homebrew/Caskroom")!
        } else { // Intel
            return URL(string: "/usr/local/Caskroom")!
        }
    }()
    public static let tapPath: URL = {
        if FileManager.default.fileExists(atPath: "/opt/homebrew/Library/Taps") { // Apple Sillicon
            return URL(string: "/opt/homebrew/Library/Taps")!
        } else { // Intel
            return URL(string: "/usr/local/Homebrew/Library/Taps")!
        }
    }()
    
    /// **Storage for tagging**
    public static let documentsDirectoryPath: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Reminders", conformingTo: .directory)
    public static let metadataFilePath: URL = documentsDirectoryPath.appendingPathComponent("Metadata", conformingTo: .data)
    
    /// **Brew cache**
    public static let brewCachePath: URL = URL(string: NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!)!.appendingPathComponent("Caches", conformingTo: .directory).appendingPathComponent("Homebrew", conformingTo: .directory) // /Users/thomas/Library/Caches/Homebrew
    
    /// These two have the symlinks to the actual downloads
    public static let brewCachedFormulaeDownloadsPath: URL = brewCachePath
    public static let brewCachedCasksDownloadsPath: URL = brewCachePath.appendingPathComponent("Cask", conformingTo: .directory)
    
    /// This one has all the downloaded files themselves
    public static let brewCachedDownloadsPath: URL = brewCachePath.appendingPathComponent("downloads", conformingTo: .directory)
    
    // MARK: - Proxy settings
    public static let proxySettings: NetworkProxy? = {
        do {
            return try getProxySettings()
        } catch let proxyRetrievalError as ProxyRetrievalError {
            switch proxyRetrievalError {
            case .couldNotGetProxyStatus:
                AppLogger.homeBrew.log(level: .error, "Could not get proxy status")
                return nil
            case .couldNotGetProxyHost:
                AppLogger.homeBrew.log(level: .error, "Could not get proxy host")
                return nil
            case .couldNotGetProxyPort:
                AppLogger.homeBrew.log(level: .error, "Could not get proxy port")
                return nil
            }
        } catch let unknownError {
            AppLogger.homeBrew.log(level: .error, "Something got fucked up: \(unknownError.localizedDescription)")
            return nil
        }
    }()
    
    public static func topPackagesDownloadPath(numberOfDays: Int = 30, isCask: Bool) -> URL {
        if isCask {
            return URL(string: "https://formulae.brew.sh/api/analytics/install/homebrew-core/\(numberOfDays)d.json")!
        } else {
            return URL(string: "https://formulae.brew.sh/api/analytics/cask-install/homebrew-cask/\(numberOfDays)d.json")!
        }
    }
    
    public static let osVersionString: (lookupName: String, fullName: String) = {
        let versionDictionary: [Int: (lookupName: String, fullName: String)] = [
            14: ("sonoma", "Sonoma"),
            13: ("ventura", "Ventura"),
            12: ("monterey", "Monterey"),
            11: ("big_sur", "Big Sur"),
            10: ("legacy", "Legacy")
        ]
        let macOSVersionTheUserIsRunning: Int = ProcessInfo.processInfo.operatingSystemVersion.majorVersion
        return versionDictionary[macOSVersionTheUserIsRunning, default: ("legacy", "Legacy")]
    }()
}
