//
//  BrewService.swift
//  RemindersMacOS
//
//  Created by Thomas on 09.11.23.
//

import Foundation
/*import Reminders_Domain
 
 public class BrewService {
 public static let shared = BrewService()
 
 //private var brewBookMarkUrl: URL? = nil
 private var brewExecutableBookMarkUrl: URL? = nil
 //private let brewBookMarkKey: String = "homeBrewExecutableDirBookmarkKey"
 private let brewExecutableBookMarkKey: String = "homeBrewExecutableBookmarkKey"
 
 @MainActor
 public func brew(_ arguments: [String]) async -> TerminalOutput {
 if brewExecutableBookMarkUrl == nil {
 brewExecutableBookMarkUrl = FileManagerService.shared.initializeBrewAccess(brewBookMarkKey: brewExecutableBookMarkKey, wait: true)
 }
 if let _ = brewExecutableBookMarkUrl {
 AppLogger.homeBrew.log("Start accessing FileManagerService for brew: \(brewExecutableBookMarkUrl!)")
 //if(brewExecutableBookMarkUrl!.startAccessingSecurityScopedResource()) {
 async let terminalOutput = await brew(arguments)
 AppLogger.homeBrew.log("Terminating FileManagerService for brew")
 //brewExecutableBookMarkUrl!.stopAccessingSecurityScopedResource()
 return await terminalOutput
 //}
 }
 return .init(standardOutput: "", standardError: "")
 }
 
 @MainActor
 public func brewReadyForAsyncStream() -> URL? {
 if brewExecutableBookMarkUrl == nil {
 brewExecutableBookMarkUrl = FileManagerService.shared.initializeBrewAccess(brewBookMarkKey: brewExecutableBookMarkKey, wait: true)
 }
 if let _ = brewExecutableBookMarkUrl {
 AppLogger.homeBrew.log("Start accessing FileManagerService for brew: \(brewExecutableBookMarkUrl!)")
 //if(brewExecutableBookMarkUrl!.startAccessingSecurityScopedResource()) {
 return brewExecutableBookMarkUrl
 //}
 }
 return nil
 }
 
 public func brewTerminate() {
 if let _ = brewExecutableBookMarkUrl {
 AppLogger.homeBrew.log("Terminating FileManagerService for brew")
 //brewExecutableBookMarkUrl!.stopAccessingSecurityScopedResource()
 }
 }
 }
 */
