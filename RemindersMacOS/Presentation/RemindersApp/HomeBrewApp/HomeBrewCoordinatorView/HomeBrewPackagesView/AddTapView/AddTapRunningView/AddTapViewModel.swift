//
//  AddTapViewModel.swift
//  RemindersMacOS
//
//  Created by Thomas on 27.10.23.
//

import Foundation
import Reminders_Domain

class AddTapViewModel: ObservableObject {
    private var addTapUseCase: AddTapUCProtocol = DIContainer.shared.resolve()
    
    @Published var tapName: String = ""
    
    @Published var actionSuccess: Executable<TypeOfResult> = .notRequested
    
    init( addTapUseCase: AddTapUCProtocol) {
        self.addTapUseCase = addTapUseCase
    }
    
    func startAddingTap(tapName: String) -> Void {
        self.tapName = tapName
        addTapUseCase.execute(tapName: tapName, success: executableSubject(\.actionSuccess) )
    }
    
    func startAddingTap() -> Void {
        startAddingTap(tapName: tapName)
    }
}
