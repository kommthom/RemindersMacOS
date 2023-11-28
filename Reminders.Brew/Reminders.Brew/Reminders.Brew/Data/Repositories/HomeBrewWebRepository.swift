//
//  HomeBrewWebRepository.swift
//  RemindersMacOS
//
//  Created by Thomas on 12.10.23.
//

import Foundation
import SwiftyJSON
import Combine
import Reminders_Domain

public struct DefaultHomeBrewWebRepository: HomeBrewWebRepositoryProtocol {
    private func loadUpTopPackages(numberOfDays: Int = 30, isCask: Bool) async throws -> [TopPackage] {
        do {
            let brewBackendResponse = try await downloadDataFromURL(HomeBrewConstants.topPackagesDownloadPath(numberOfDays: numberOfDays, isCask: isCask))
            do {
                return try await parseDownloadedTopPackageData(data: brewBackendResponse, isCask: isCask, numberOfDays: numberOfDays)
            } catch let packageParsingError {
                AppLogger.homeBrew.log("Failed while parsing top packages: \(packageParsingError)")
                throw packageParsingError
            }
        } catch let brewApiError as DataDownloadingError {
            switch brewApiError {
                case .invalidResponseCode:
                    AppLogger.homeBrew.log("Received invalid response code from Brew")
                    throw brewApiError
                case .noDataReceived:
                    AppLogger.homeBrew.log("Received no data from Brew")
                    throw brewApiError
            }
        }
    }
    private func parseDownloadedTopPackageData(data: Data, isCask: Bool, numberOfDays: Int) async throws -> [TopPackage] {
        do {
            var packageTracker: [TopPackage] = .init()
            let parsedJSON: JSON = try JSON(data: data)
            for packageDefinition in parsedJSON["formulae"] {
                /// formulaInfo is a tuple of (String: JSON)
                /// First, we have to get the second element of the tuple (the JSON), then that is an array with the formula info. However, there's only one element in it, so we choose it
                let packageInfo = packageDefinition.1.arrayValue[0]
                let packageInstalledCount: Int = Int(packageInfo["count"].stringValue.replacingOccurrences(of: ",", with: "")) ?? 0
                /// Immediately throw away any package that has fewer than 1000 downloads to save on computing power
                if packageInstalledCount > 33 * numberOfDays {
                    let packageName: String = packageInfo[isCask ? "cask" : "formula"].stringValue
                    packageTracker.append(TopPackage(packageName: packageName, packageDownloads: packageInstalledCount))
                }
            }
            return packageTracker
        } catch let JSONParsingError {
            AppLogger.homeBrew.log("Failed while parsing JSON: \(JSONParsingError.localizedDescription)")
            throw JSONParsingError
        }
    }
    
    public func topPackages(isCask: Bool, numberOfDays: Int = 30) -> AnyPublisher<[TopPackage], Error> {
        let emptyTopPackagesList = CurrentValueSubject<Bool, Error>(true)
        return emptyTopPackagesList
            .filter { $0 }
            .asyncMap { _ in
                try await loadUpTopPackages(numberOfDays: numberOfDays, isCask: isCask)
            }
            .eraseToAnyPublisher()
    }
    
    public init() {
        
    }
}

public struct MockedHomeBrewWebRepository: HomeBrewWebRepositoryProtocol {
    public func topPackages(isCask: Bool, numberOfDays: Int = 30) -> AnyPublisher<[TopPackage], Error> {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public init() {
        
    }
}
