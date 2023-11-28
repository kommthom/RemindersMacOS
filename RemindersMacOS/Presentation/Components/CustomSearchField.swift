//
//  CustomSearchField.swift
//  RemindersMacOS
//
//  Created by Thomas on 14.10.23.
//

import Foundation
import SwiftUI

struct CustomSearchField: NSViewRepresentable {
    @Binding var search: String
    @State var customPromptText: String?

    class Coordinator: NSObject, NSSearchFieldDelegate {
        var parent: CustomSearchField

        init(_ parent: CustomSearchField) {
            self.parent = parent
        }

        func controlTextDidChange(_ notification: Notification) {
            guard let searchField = notification.object as? NSSearchField else { return }
            parent.search = searchField.stringValue
        }
    }

    func makeNSView(context _: Context) -> NSSearchField {
        let searchField = NSSearchField(frame: .zero)

        if let customPromptText {
            searchField.placeholderString = NSLocalizedString(customPromptText, comment: "")
        }
        return searchField
    }

    func updateNSView(_ searchField: NSSearchField, context: Context) {
        searchField.stringValue = search
        searchField.delegate = context.coordinator
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}
