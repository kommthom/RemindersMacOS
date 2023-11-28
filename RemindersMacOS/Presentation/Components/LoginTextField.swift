//
//  LoginTextField.swift
//  RemindersMacOS
//
//  Created by Thomas on 11.09.23.
//

import SwiftUI

struct LoginTextField: View {
    let hintString: LocalizedStringKey
    let inputString: Binding<String>
    @State var isSecured: Bool = true
    @State var isPassword: Bool = false
    
    var body: some View {
        if isPassword {
            ZStack (alignment: .trailing){
                if isSecured {
                    SecureField(hintString, text: inputString).customizeTextField(textContent: .password)
                } else {
                    TextField(hintString, text: inputString).customizeTextField(textContent: .password)
                }
                Button (
                    action: {
                        withAnimation() {
                            isSecured.toggle()
                        }
                    }, label: {
                        Image(systemName: isSecured ? "eye.slash" : "eye")
                            .tint(.gray)
                    }
                )
            }
        } else {
            TextField(hintString, text: inputString).customizeTextField(textContent: .username)
        }
    }
}

extension View {
    func customizeTextField(textContent: NSTextContentType) -> some View {
        return self.textContentType(textContent)
            .autocorrectionDisabled()
            .font(Font.system(size: 24, weight: .regular, design: .default))
            .foregroundColor(Color.black)
            .frame(height: 60)
            .padding(.horizontal, 16)
            .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.accentColor, lineWidth: 2))
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
    }
}

struct LoginTextView_Previews: PreviewProvider {
    @State static var input: String = ""
    static var previews: some View {
        LoginTextField(hintString: "test", inputString: $input)
    }
}
