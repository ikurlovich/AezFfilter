//
//  EmailUI.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 09.05.24.
//

import SwiftUI

struct EmailUI: View {
    @State private var isValidEmail = true
    @Binding var email: String
    
    var body: some View {
        VStack {
            HStack {
                Text("e-mail")
                    .foregroundStyle(.accent)
                
                Spacer()
            }
            
            HStack() {
                TextField("example@example", text: $email, onEditingChanged: { _ in
                    isValidEmail = validateEmail(email: email)
                })
                    .padding()
                    .foregroundStyle(.accent)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(isValidEmail || email.isEmpty ? .accent : .red, lineWidth: 2)
                    )
            }
        }
        .frame(width: 300, height: 50)
    }
    
    func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}

#Preview {
    EmailUI(email: .constant(""))
}
