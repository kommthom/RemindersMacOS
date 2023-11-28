//
//  ViewExtension.swift
//  RemindersMacOS
//
//  Created by Thomas on 25.10.23.
//

import SwiftUI

extension View {
    func neumorphismStyle() -> some View {
        self
            .background(.white)
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.2), radius: 10, x:10, y:10)
    }
}
