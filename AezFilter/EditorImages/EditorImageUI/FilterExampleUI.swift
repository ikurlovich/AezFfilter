//
//  FilterExampleUI.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 09.05.24.
//

import SwiftUI

struct FilterExampleUI: View {
    var buttonText: String
    var image: String
    var buttonAction: () -> Void
    
    init(_ buttonText: String, _ image: String, _ buttonAction: @escaping () -> Void) {
        self.buttonText = buttonText
        self.image = image
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        Button(action: buttonAction) {
            VStack {
                Image(image)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                Text(buttonText)
                    .foregroundStyle(.accent)
                    .bold()
            }
        }
    }
}

#Preview {
    FilterExampleUI("Сепея", "FilterSepia") { print("Sepia") }
}
