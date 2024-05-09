//
//  AuthorizationView.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 09.05.24.
//

import SwiftUI

struct AuthorizationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isButtonPressed = false
    
    @State private var showsAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    enum whatWindowShow: String, CaseIterable {
        case first, second
    }
    
    @State private var windowShow: whatWindowShow = .first
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                HStack(spacing: 0) {
                    Text("Aez")
                        .foregroundStyle(.accent)
                    Text("Filter")
                }
                .bold()
                .font(.custom("22", size: 60))
                
                EmailUI(email: $email)
                
                PasswordUI(password: $password, name: "Пароль")
                
                VStack {
                    UniversalButtonUI("Войти", Color.accent) {
                        entryAccount()
                    }
                    
                    UniversalButtonUI("Регистрация", Color.accent) {
                        windowShow = .second
                        isButtonPressed = true
                    }
                }
                
            }
            .padding(.horizontal, 20)
            .navigationDestination(isPresented: $isButtonPressed) {
                switch windowShow {
                case .first:
                    EditorImageView()
                        .navigationBarBackButtonHidden(true)
                case .second:
                    RegistrationView()
                }
            }

            .alert(isPresented: $showsAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK") )
                )
            }
        }
    }
    
    private func entryAccount() {
        if !email.isEmpty && !password.isEmpty {
            windowShow = .first
            isButtonPressed = true
        } else {
            alertTitle = "Ошибка входа"
            alertMessage = "Пожалуйста проверьте правильность введённых данных"
            showsAlert = true
        }
    }
}

#Preview {
    NavigationStack {
        AuthorizationView()
    }
}
