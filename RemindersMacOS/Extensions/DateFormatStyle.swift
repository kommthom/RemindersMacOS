//
//  DateFormatStyle.swift
//  RemindersMacOS
//
//  Created by Thomas on 12.10.23.
//

import Foundation

extension FormatStyle where Self == Date.FormatStyle
{
    static var packageInstallationStyle: Self
    {
        Self.dateTime.day().month(.wide).year().weekday(.wide).hour().minute()
    }
}
