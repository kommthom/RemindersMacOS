//
//  LogInGitHubView.swift
//  RemindersMacOS
//
//  Created by Thomas on 11.09.23.
//

import SwiftUI
import ComposableArchitecture
import Reminders_Domain

struct LogInGitHubView: View {
    let store: StoreOf<LogInGitHub>
    @StateObject private var viewModel: LogInGitHubViewModel = DIContainer.shared.resolve()
    @EnvironmentObject private var isGitHubAuthenticated: ObservableBool
    
    var body: some View {
        WithViewStore(store, observe: { $0 } ) { viewStore in
            ZStack {
                Color("BackgroundBlack").edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    Image("reminders")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 160, height: 160, alignment: .center)
                        .padding(.top, 60)
                    Text("githublogin.text.githubsearch")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.accentColor)
                    Spacer()
                    VStack {
                        
                        // Text field for username
                        LoginTextField(hintString: "githublogin.text.username", inputString: $viewModel.credential.username)
                        
                        Spacer().frame(height: 20)
                        
                        // Text field for password
                        LoginTextField(hintString: "githublogin.text.password", inputString: $viewModel.credential.password
                                       , isPassword: true)
                        
                        Spacer().frame(height: 50)
                        HStack {
                            CancelButton(label: "buttoncancel") {
                                viewStore.send(.goBackTapped)
                            }
                            LoginButton(label: "githublogin.button.signin" ){
                                viewModel.performLogin()
                                Delay(1).performWork {
                                    isGitHubAuthenticated.value = viewModel.isAuthenticated
                                    viewStore.send(.goBackTapped)
                                }
                            }
                            .disabled(viewModel.loginDisabled)
                        }
                    }.padding()
                    
                    Spacer()
                }
                .alert(item: $viewModel.error) { error in
                    return Alert(title: Text("alert.error.text"),
                                 message: Text(String(describing: error.localizedDescription)),
                                 dismissButton: .cancel())
                }
            }
        }
    }
}
