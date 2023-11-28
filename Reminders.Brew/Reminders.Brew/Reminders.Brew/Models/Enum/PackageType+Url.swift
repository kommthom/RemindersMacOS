//
//  PackageType+Url.swift
//  Reminders.Brew
//
//  Created by Thomas on 13.11.23.
//

import Reminders_Domain

extension PackageType {
    
    public var url: URL {
        switch self {
        case .formula: HomeBrewConstants.brewCellarPath
        case .cask: HomeBrewConstants.brewCaskPath
        case .tap: HomeBrewConstants.tapPath
        }
    }
}
