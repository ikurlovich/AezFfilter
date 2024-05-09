//
//  UniversalButtonUI.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 09.05.24.
//

import SwiftUI

struct UniversalButtonUI: View {
    var buttonText: String
    var buttonAction: () -> Void
    var buttonColor: Color
    
    init(_ buttonText: String, _ buttonColor: Color, _ buttonAction: @escaping () -> Void) {
        self.buttonText = buttonText
        self.buttonAction = buttonAction
        self.buttonColor = buttonColor
    }

    var body: some View {
        VStack {
            Button(action: buttonAction) {
                    Text(buttonText)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .frame(width: 300, height: 50)
                    .background(buttonColor)
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    UniversalButtonUI("Пример", Color.orange) {
        print("Registration done")
    }
}

