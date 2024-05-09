//
//  PasswordUI.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 09.05.24.
//

import SwiftUI

struct PasswordUI: View {
    @Binding var password: String
    var name: String
    
    var body: some View {
        VStack {
            HStack {
                Text(name)
                    .foregroundStyle(.accent)
                Spacer()
            }
            
            HStack() {
                SecureField("******", text: $password)
                    .padding()
                    .foregroundStyle(.accent)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.accent, lineWidth: 2)
                    )
            }
        }
        .frame(width: 300, height: 50)
    }
}

#Preview {
    PasswordUI(password: .constant(""), name: "Пароль")
}
