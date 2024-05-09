//
//  EditorImageView.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 06.05.24.
//

import SwiftUI

struct EditorImageView: View {
    @StateObject var vm = EditorViewModel()
    
    var body: some View {
        VStack {
            EditorToolbarUI(vm: vm)
            
            Spacer()
            
            EditorProcessedImageUI(vm: vm)
            
            Spacer()
            
            if vm.processedImage != nil {
                EditorInstrumentsUI(vm: vm)
                EditorFiltersUI(vm: vm)
            }
        }
        .alert(isPresented: $vm.isShowAlert) {
            Alert(
                title: Text("Предупреждение!"),
                message: Text("Вы собираетесь отменить редактирование выбранной фотографии?"),
                primaryButton: .cancel(Text("Нет"), action: {  }),
                secondaryButton: .default(Text("Да"), action: { vm.clearImage()})
            )
        }
    }
}

#Preview {
    EditorImageView()
}
