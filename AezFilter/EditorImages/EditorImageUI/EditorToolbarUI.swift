//
//  EditorToolbarUI.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 09.05.24.
//

import SwiftUI

struct EditorToolbarUI: View {
    @ObservedObject var vm: EditorViewModel
    
    var body: some View {
        ZStack {
            Text("Редактор фото")
                .font(.title3)
                .bold()
                .foregroundStyle(.accent)
            
            HStack {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .frame(width: 13, height: 20)
                    .foregroundStyle(.accent)
                    .padding(.horizontal)
                    .onTapGesture {
                        if vm.processedImage != nil {
                            vm.isShowAlert = true
                        }
                    }
                
                Spacer()
                
                if vm.processedImage != nil {
                    ShareLink(item: vm.processedImage ?? Image(systemName: "photo"), preview: SharePreview("AezFilter изображение", image: vm.processedImage ?? Image(systemName: "photo"))) {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .frame(width: 20, height: 30)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    EditorToolbarUI(vm: EditorViewModel())
}
