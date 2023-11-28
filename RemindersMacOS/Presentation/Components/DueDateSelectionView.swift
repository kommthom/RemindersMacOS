//
//  DueDateSelectionView.swift
//  RemindersMacOS
//
//  Created by David Malicke on 2/13/22.
//

import SwiftUI
import Reminders_Domain

struct DueDateSelectionView: View {
    
    @Binding var dueDate: DueDate?
    @State private var selectedDate: Date = Date.today
    @State private var showCalendar: Bool = false
    
    var body: some View {
        Menu {
            Button {
                dueDate = .today
            } label: {
                VStack {
                    Text("duedate.button.today-\n\(Date.today.formatAsString)")
                }
            }
            Button {
                dueDate = .tomorrow
            } label: {
                VStack {
                    Text("duedate.button.tomorrow-\n\(Date.tomorrow.formatAsString)")
                }
            }
            Button {
                showCalendar = true
            } label: {
                Text("duedate.button.custom")
            }
        } label: {
            Label(dueDate == nil ? "duedate.menu.adddate" : dueDate!.title, systemImage: "calendar")
        }.menuStyle(.borderedButton)
            .fixedSize()
            .popover(isPresented: $showCalendar) {
                DatePicker("duedate.datepicker.custom", selection: $selectedDate, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.graphical)
                    .onChange(of: selectedDate) { newValue, _ in
                        dueDate = .custom(newValue)
                        showCalendar = false
                    }
                
            }
    }
}

struct DueDateSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DueDateSelectionView(dueDate: .constant(nil))
    }
}
