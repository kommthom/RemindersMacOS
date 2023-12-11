//
//  SettingsPaneTemplate.swift
//  RemindersMacOS
//
//  Created by Thomas on 05.12.23.
//

import SwiftUI

struct SettingsPaneTemplate<Content: View>: View
{
    @ViewBuilder var paneContent: Content

    var body: some View
    {
        paneContent
            .padding()
            .frame(minWidth: 470, minHeight: 50)
            .fixedSize()
    }
}
