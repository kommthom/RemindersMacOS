//
//  GetAccessRightsForFolder.swift
//  RemindersMacOS
//
//  Created by Thomas on 06.11.23.
//

import Foundation
/*import AppKit
 import SwiftyJSON
 import UniformTypeIdentifiers.UTType
 import Reminders_Domain
 
 public class FileManagerService {
 public static let shared = FileManagerService()
 
 private let semaphore = DispatchSemaphore(value: 1)
 
 private var bookMarkUrl: URL? = nil
 private var actualType: PackageType = .formula
 
 public func semaphoreWait() {
 AppLogger.homeBrew.log("Semaphore wait call")
 semaphore.wait()
 }
 
 public func semaphoreSignal() {
 AppLogger.homeBrew.log("Semaphore signal call")
 semaphore.signal()
 }
 
 @MainActor
 public func initializeBrewAccess(brewBookMarkKey: String, wait: Bool = false) -> URL? {
 var brewBookMarkUrl: URL? = nil
 AppLogger.homeBrew.log("Initializing FileManagerService for brew")
 if let bookMarkData = UserDefaults.standard.data(forKey: brewBookMarkKey) {
 brewBookMarkUrl = restoreFileAccess(with: bookMarkData, signal: wait)
 } else {
 AppLogger.homeBrew.log("The bookmark for brew Executable does not yet exist in UserDefaults! So create \(brewBookMarkKey)")
 brewBookMarkUrl = promptForFilePermission(startPath: HomeBrewConstants.brewExecutablePath.absoluteString, bookMarkKey: brewBookMarkKey, signal: wait)
 }
 if brewBookMarkUrl == nil {
 if wait { semaphoreSignal() }
 return nil
 } else {
 return brewBookMarkUrl
 }
 }
 
 @MainActor
 public func initializeAccess(packageType: PackageType, wait: Bool = false) -> Bool {
 if packageType != actualType || bookMarkUrl == nil {
 if wait { FileManagerService.shared.semaphoreWait() }
 if bookMarkUrl != nil {
 terminateAccess()
 }
 actualType = packageType
 AppLogger.homeBrew.log("Initializing FileManagerService Type: \(actualType.description)")
 if let bookMarkData = UserDefaults.standard.data(forKey: actualType.bookmarkKey) {
 bookMarkUrl = restoreFileAccess(with: bookMarkData, signal: wait)
 } else {
 AppLogger.homeBrew.log("The bookmark for \(actualType.description) does not yet exist in UserDefaults! So create \(actualType.bookmarkKey)")
 bookMarkUrl = promptForDirectoryPermission(startPath: actualType.url.absoluteString, bookMarkKey: actualType.bookmarkKey, signal: wait)
 }
 if bookMarkUrl == nil {
 if wait { semaphoreSignal() }
 } else {
 //if(bookMarkUrl!.startAccessingSecurityScopedResource()) {
 return true
 //}
 }
 return false
 }
 return true
 }
 
 public func terminateAccess() {
 if let _ = bookMarkUrl {
 AppLogger.homeBrew.log("Terminating FileManagerService Type: \(actualType.description)")
 //bookMarkUrl!.stopAccessingSecurityScopedResource()
 bookMarkUrl = nil
 }
 }
 
 @MainActor
 public func directorySize(packageType: PackageType, appendingPathComponent: String = "") -> Int64 {
 let contents: [URL]
 contents = contentsOfDirectory(packageType: packageType, appendingPathComponent: appendingPathComponent, includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey], options: .skipsHiddenFiles)
 var size: Int64 = 0
 for url in contents {
 let isDirectoryResourceValue: URLResourceValues
 do {
 isDirectoryResourceValue = try url.resourceValues(forKeys: [.isDirectoryKey])
 } catch {
 continue
 }
 if isDirectoryResourceValue.isDirectory == true {
 size += directorySize(packageType: packageType, appendingPathComponent: appendingPathComponent.isEmpty ? url.lastPathComponent : "\(appendingPathComponent)/\(url.lastPathComponent)")
 } else {
 let fileSizeResourceValue: URLResourceValues
 do {
 fileSizeResourceValue = try url.resourceValues(forKeys: [.fileSizeKey])
 } catch {
 continue
 }
 size += Int64(fileSizeResourceValue.fileSize ?? 0)
 }
 }
 return size
 }
 
 //User domain version
 public func directorySize(url: URL) -> Int64 {
 let contents: [URL]
 do {
 contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey])
 } catch {
 return 0
 }
 var size: Int64 = 0
 for url in contents {
 let isDirectoryResourceValue: URLResourceValues
 do {
 isDirectoryResourceValue = try url.resourceValues(forKeys: [.isDirectoryKey])
 } catch {
 continue
 }
 if isDirectoryResourceValue.isDirectory == true {
 size += FileManagerService.shared.directorySize(url: url)
 } else {
 let fileSizeResourceValue: URLResourceValues
 do {
 fileSizeResourceValue = try url.resourceValues(forKeys: [.fileSizeKey])
 } catch {
 continue
 }
 size += Int64(fileSizeResourceValue.fileSize ?? 0)
 }
 }
 return size
 }
 
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
 return Int(FileManagerService.shared.directorySize(url: HomeBrewConstants.brewCachedDownloadsPath))
 }
 
 public var homeDirectoryForCurrentUser: URL {
 FileManager.default.homeDirectoryForCurrentUser
 }
 
 @MainActor
 public func attributesOfItem(packageType: PackageType, appendingPathComponent: String = "") -> [FileAttributeKey : Any] {
 let _ = initializeAccess(packageType: packageType)
 if let _ = bookMarkUrl {
 do {
 var targetFolder: URL = bookMarkUrl!
 if !appendingPathComponent.isEmpty {
 targetFolder = targetFolder.appendingPathComponent(appendingPathComponent, conformingTo: .folder)
 }
 return try FileManager.default.attributesOfItem(atPath: targetFolder.path)
 } catch let error {
 AppLogger.homeBrew.log(level: .error, "FileManager.default.attributesOfItem(atPath: \(bookMarkUrl!.path)/\(appendingPathComponent)): \(error.localizedDescription)")
 }
 }
 return .init()
 }
 
 @MainActor
 public func contentsOfDirectory(packageType: PackageType, appendingPathComponent: String = "", includingPropertiesForKeys: [URLResourceKey]? = nil, options: FileManager.DirectoryEnumerationOptions? = nil) -> [URL] {
 let _ = initializeAccess(packageType: packageType)
 if let _ = bookMarkUrl {
 do {
 var targetFolder: URL = bookMarkUrl!
 //let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey, .isDirectoryKey], options: [.skipsHiddenFiles, .skipsPackageDescendants])
 if !appendingPathComponent.isEmpty {
 targetFolder = targetFolder.appendingPathComponent(appendingPathComponent, conformingTo: .folder)
 }
 if options == nil {
 return try FileManager.default.contentsOfDirectory(at: targetFolder, includingPropertiesForKeys: includingPropertiesForKeys)
 } else {
 return try FileManager.default.contentsOfDirectory(at: targetFolder, includingPropertiesForKeys: includingPropertiesForKeys, options: options!)
 }
 } catch let error {
 AppLogger.homeBrew.log(level: .error, "FileManager.default.contentsOfDirectory(atPath: \(bookMarkUrl!.path): \(error.localizedDescription)")
 return .init()
 }
 }
 return []
 }
 
 @MainActor
 public func parseJSON(packageType: PackageType, appendingPathComponent: String = "", appendingFileName: String) -> JSON? {
 let _ = initializeAccess(packageType: packageType)
 if let _ = bookMarkUrl {
 do {
 var target: URL = bookMarkUrl!
 if !appendingPathComponent.isEmpty {
 target = target.appendingPathComponent(appendingPathComponent, conformingTo: .folder)
 }
 target = target.appendingPathComponent(appendingFileName, conformingTo: .json)
 return try Reminders_Brew.parseJSON(from: String(contentsOfFile: target.path, encoding: .utf8))
 } catch {
 AppLogger.homeBrew.log(level: .error, "parseJSON(packageType: \(packageType.description), appendingPathComponent: \(appendingPathComponent), appendingFileName: \(appendingFileName) failed: \(error.localizedDescription)")
 }
 }
 return nil
 }
 
 @MainActor
 public func fileExists(packageType: PackageType, appendingPathComponent: String = "", appendingFileName: String, conformingTo: UTType = .json) -> Bool {
 let _ = initializeAccess(packageType: packageType)
 if let _ = bookMarkUrl {
 var target: URL = bookMarkUrl!
 if !appendingPathComponent.isEmpty {
 target = target.appendingPathComponent(appendingPathComponent, conformingTo: .folder)
 }
 target = target.appendingPathComponent(appendingFileName, conformingTo: conformingTo)
 return FileManager.default.fileExists(atPath: target.path)
 }
 return false
 }
 
 @MainActor
 public func getContentsOfFolder(packageType: PackageType, appendingPathComponent: String = "", includingPropertiesForKeys: [URLResourceKey]? = nil, options: FileManager.DirectoryEnumerationOptions? = nil) -> [String] {
 let _ = initializeAccess(packageType: packageType)
 if let _ = bookMarkUrl {
 do {
 return try FileManager.default.contentsOfDirectory(atPath: bookMarkUrl!.path)
 } catch let error {
 AppLogger.homeBrew.log(level: .error, "FileManager.default.contentsOfDirectory(atPath: \(bookMarkUrl!.path)/\(appendingPathComponent)): \(error.localizedDescription)")
 }
 }
 return []
 }
 
 private func restoreFileAccess(with bookmarkData: Data, signal: Bool) -> URL? {
 do {
 AppLogger.homeBrew.log("Restore File Access")
 var isStale = false
 let url = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
 if isStale {
 // bookmarks could become stale as the OS changes
 AppLogger.homeBrew.log("Bookmark is stale, need to save a new one... ")
 AppLogger.homeBrew.log("Save bookmark in UserDefaults \(self.actualType.bookmarkKey)")
 UserDefaults.standard.set(bookmarkData, forKey: self.actualType.bookmarkKey)
 if signal { FileManagerService.shared.semaphore.signal() }
 } else {
 AppLogger.homeBrew.log("Restoring File Access finished: \(url)")
 FileManagerService.shared.semaphore.signal()
 }
 return url
 } catch {
 AppLogger.homeBrew.log(level: .error, "Error resolving bookmark:" + error.localizedDescription)
 return nil
 }
 }
 
 @MainActor
 private func promptForDirectoryPermission(startPath: String, bookMarkKey: String, signal: Bool) -> URL? {
 var url: URL? = nil
 assert(Thread.isMainThread)
 let openPanel = NSOpenPanel()
 AppLogger.homeBrew.log("Open Panel \(startPath)")
 openPanel.message = "Select HomeBrew directory: \(startPath)"
 openPanel.prompt = "Select"
 openPanel.directoryURL = NSURL.fileURL(withPath: startPath, isDirectory: true)
 //openPanel.allowedFileTypes = ["none"]
 openPanel.canCreateDirectories = false;
 openPanel.allowsMultipleSelection = false
 openPanel.allowedContentTypes = [.folder]
 openPanel.allowsOtherFileTypes = false
 openPanel.canChooseFiles = false
 openPanel.canChooseDirectories = true
 openPanel.begin(completionHandler: { result in
 if(result == .OK) {
 do {
 let bookmarkData = try openPanel.url!.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
 AppLogger.homeBrew.log("Save bookmark in UserDefaults \(bookMarkKey)")
 UserDefaults.standard.set(bookmarkData, forKey: bookMarkKey);
 AppLogger.homeBrew.log("chosen folder: \(openPanel.urls)") // this contains the chosen folder
 url = openPanel.urls.first
 if signal { FileManagerService.shared.semaphore.signal() }
 } catch {
 AppLogger.homeBrew.log(level: .error, "Error creating the bookmark: \(error.localizedDescription)")
 }
 } else {
 AppLogger.homeBrew.log("Choosing a directory was not successful")
 }
 })
 return url
 }
 
 @MainActor
 private func promptForFilePermission(startPath: String, bookMarkKey: String, signal: Bool) -> URL? {
 var url: URL? = nil
 assert(Thread.isMainThread)
 let openPanel = NSOpenPanel()
 AppLogger.homeBrew.log("Open Panel \(startPath)")
 openPanel.message = "Select HomeBrew executable: \(startPath)"
 openPanel.prompt = "Select"
 openPanel.directoryURL = NSURL.fileURL(withPath: startPath, isDirectory: false)
 //openPanel.allowedFileTypes = ["none"]
 openPanel.canCreateDirectories = false;
 openPanel.allowsMultipleSelection = false
 openPanel.allowedContentTypes = [.shellScript]
 openPanel.allowsOtherFileTypes = false
 openPanel.canChooseFiles = true
 openPanel.canChooseDirectories = false
 openPanel.begin(completionHandler: { result in
 if(result == .OK) {
 do {
 let bookmarkData = try openPanel.url!.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
 AppLogger.homeBrew.log("Save bookmark in UserDefaults \(bookMarkKey)")
 UserDefaults.standard.set(bookmarkData, forKey: bookMarkKey);
 AppLogger.homeBrew.log("chosen file: \(openPanel.urls)") // this contains the chosen files
 url = openPanel.urls.first
 if signal { FileManagerService.shared.semaphore.signal() }
 } catch {
 AppLogger.homeBrew.log(level: .error, "Error creating the bookmark: \(error.localizedDescription)")
 }
 } else {
 AppLogger.homeBrew.log("Choosing a directory was not successful")
 }
 })
 return url
 }
 }
 */
