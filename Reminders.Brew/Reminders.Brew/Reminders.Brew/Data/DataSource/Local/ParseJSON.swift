//
//  ParseJSON.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.10.23.
//

import Foundation
import SwiftyJSON
import Reminders_Domain

func parseJSON(from string: String) throws -> JSON {
    let data: Data = string.data(using: .utf8, allowLossyConversion: false)!
    do {
        return try JSON(data: data)
    } catch let JSONParsingError as NSError {
        AppLogger.homeBrew.log("JSON parsing failed: \(JSONParsingError.localizedDescription)")
        throw JSONError.parsingFailed
    }
}
