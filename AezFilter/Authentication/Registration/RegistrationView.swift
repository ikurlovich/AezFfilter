//
//  RegistrationView.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 09.05.24.
//

import SwiftUI
import Firebase

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var repeatPassword = ""
    
    @State private var showsAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 50) {
                EmailUI(email: $email)
                PasswordUI(password: $password, name: "Пароль")
                PasswordUI(password: $repeatPassword, name: "Повторите пароль")
                UniversalButtonUI("Регистрация", Color.accent) {
                    regAccount()
                }
            }
            .padding(.horizontal, 20)
            .navigationTitle("Регистрация")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showsAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK") )
                )
            }
        }
    }
    
    private func regAccount() {
        if password == repeatPassword && !password.isEmpty && !email.isEmpty  {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if error != nil {
                    print(error!.localizedDescription)
                    alertTitle = "Ошибка!"
                    alertMessage = "\(error!.localizedDescription)"
                    showsAlert = true
                } else {
                    alertTitle = "Успешно!"
                    alertMessage = "Вы зарегистрированы:\n\(email)\n\(password)"
                    showsAlert = true
                }
            }
        } else if !(password == repeatPassword) {
            alertTitle = "Ошибка"
            alertMessage = "Пароли не совпадают!"
            showsAlert = true
        } else {
            alertTitle = "Ошибка"
            alertMessage = "Поля не заполнены!"
            showsAlert = true
        }
    }
}

#Preview {
    NavigationView {
        RegistrationView()
    }
}
