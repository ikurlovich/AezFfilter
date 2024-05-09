//
//  AuthorizationView.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 09.05.24.
//

import SwiftUI
import Firebase

struct AuthorizationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isButtonPressed = false
    
    @State private var showsAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @StateObject var avm = AuthenticationViewModel()
    
    var body: some View {
        Group {
            if avm.userIsLoggedIn {
                EditorImageView(avm: avm)
            } else {
                content
            }
        }
            .onAppear(perform: avm.getUser)
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        avm.userIsLoggedIn.toggle()
                    }
                }
            }
    }
    
    
    var content: some View {
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
                        isButtonPressed = true
                    }
                }
                
            }
            .padding(.horizontal, 20)
            .navigationDestination(isPresented: $isButtonPressed) {
                
                RegistrationView()
                
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
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if error != nil {
                    print(error!.localizedDescription)
                    alertTitle = "Ошибка входа"
                    alertMessage = "Не удалось найти пользователя"
                    showsAlert = true
                }
            }
        } else {
            alertTitle = "Ошибка входа"
            alertMessage = "Не заполнены формы входа"
            showsAlert = true
        }
    }
}

#Preview {
    NavigationStack {
        AuthorizationView()
    }
}
