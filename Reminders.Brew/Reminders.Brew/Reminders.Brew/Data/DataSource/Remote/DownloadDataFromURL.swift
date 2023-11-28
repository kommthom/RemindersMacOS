//
//  DownloadDataFromURL.swift
//  RemindersMacOS
//
//  Created by Thomas on 30.10.23.
//

import Foundation
import Reminders_Domain

func downloadDataFromURL(_ url: URL) async throws -> Data {
    
    let sessionConfiguration = URLSessionConfiguration.default
    if HomeBrewConstants.proxySettings != nil {
        sessionConfiguration.connectionProxyDictionary = [
            kCFNetworkProxiesHTTPEnable: 1,
            kCFNetworkProxiesHTTPPort: HomeBrewConstants.proxySettings!.port,
            kCFNetworkProxiesHTTPProxy: HomeBrewConstants.proxySettings!.host
        ] as [AnyHashable: Any]
    }
    let session: URLSession = URLSession(configuration: sessionConfiguration)
    let request: URLRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
    let (data, response) = try await session.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw DataDownloadingError.invalidResponseCode
    }
    if data.isEmpty {
        throw DataDownloadingError.noDataReceived
    }
    return data
}
