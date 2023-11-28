//
//  LogInRemindersView.swift
//  RemindersMacOS
//
//  Created by Thomas on 30.09.23.
//

import ComposableArchitecture
import SwiftUI

struct LogInRemindersView: View {
    let store: StoreOf<LogInReminders>
    @StateObject private var viewModel: LogInRemindersViewModel = DIContainer.shared.resolve()
    
    var body: some View {
        ZStack {
            Color("BackgroundBlack").edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Image("reminders")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 160, height: 160, alignment: .center)
                    .padding(.top, 60)
                Text("app-name")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.accentColor)
                Spacer()
                VStack {
                    
                    // Text field for username
                    LoginTextField(hintString: "reminders.login.username", inputString: $viewModel.credential.username)
                    
                    Spacer().frame(height: 20)
                    
                    // Text field for password
                    LoginTextField(hintString: "reminders.login.password", inputString: $viewModel.credential.password
                                   , isPassword: true)
                    
                    Spacer().frame(height: 50)
                    HStack {
                        Spacer()
                        LoginButton(label: "reminders.login.button" ){
                            viewModel.performLogin()
                            if viewModel.isAuthenticated {
                                store.send(.loggedIn)
                            }
                        }
                        .disabled(viewModel.loginDisabled)
                    }
                }.padding()
                
                Spacer()
            }
            .alert(item: $viewModel.error) { error in
                return Alert(title: Text("alert.error.title"),
                             message: Text(String(describing: error.localizedDescription)),
                             dismissButton: .cancel())
            }
            .frame(minWidth: Geometries.main.sidebarWidth[AppSection.reminders.rawValue] * 1.2, minHeight: Geometries.main.content[AppSection.reminders.rawValue].height * 0.8)
        }
    }
}
