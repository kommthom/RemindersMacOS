//
//  CancelButton.swift
//  RemindersMacOS
//
//  Created by Thomas on 11.09.23.
//

import SwiftUI

struct CancelButton: View {
    let label: LocalizedStringKey
    var backgroundColor: Color = Color.white
    var foregroundColor: Color = Color.accentColor
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Font.system(size: 24, weight:.heavy, design: .default))
                .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                .foregroundColor(foregroundColor)
        }
        .buttonStyle(changeOpacityStyle(color: backgroundColor))
    }
}

struct CancelButton_Previews: PreviewProvider {
    static var previews: some View {
        CancelButton(label: "Cancel", action: {})
    }
}

