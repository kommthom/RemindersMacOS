//
//  CalendarButtonView.swift
//  RemindersMacOS
//
//  Created by David Malicke on 2/14/22.
//

import SwiftUI

struct CalendarButtonView: View {
    let title: String
    @Binding var showCalendar: Bool
    @State var selectedDate: Date = Date.today
    var onSelected: (Date) -> Void
    
    var body: some View {
        VStack {
            Button(title) {
                showCalendar = true
            }.popover(isPresented: $showCalendar) {
                DatePicker("calendarbutton.datepicker.custom", selection: $selectedDate, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.graphical)
                    .onChange(of: selectedDate) { newValue, _ in
                        onSelected(newValue)
                        showCalendar = false
                    }
            }
        }
    }
}

struct CalendarButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarButtonView(title: "calendarbutton.datepicker.custo", showCalendar: .constant(true), onSelected: { _ in })
    }
}
