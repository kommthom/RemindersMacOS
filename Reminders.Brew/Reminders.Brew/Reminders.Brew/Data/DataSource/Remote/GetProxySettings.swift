//
//  GetProxySettings.swift
//  RemindersMacOS
//
//  Created by Thomas on 30.10.23.
//

import Foundation
import Reminders_Domain

func getProxySettings() throws -> NetworkProxy? {
    let proxySettings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() as? [String: Any]
    guard let httpProxyHost = proxySettings?[kCFNetworkProxiesHTTPProxy as String] as? String else {
        throw ProxyRetrievalError.couldNotGetProxyHost
    }
    guard let httpProxyPort = proxySettings?[kCFNetworkProxiesHTTPPort as String] as? Int else {
        throw ProxyRetrievalError.couldNotGetProxyPort
    }
    return NetworkProxy(host: httpProxyHost, port: httpProxyPort)
}
