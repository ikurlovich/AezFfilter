//
//  EditorProcessedImageUI.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 09.05.24.
//

import SwiftUI
import PhotosUI

struct EditorProcessedImageUI: View {
    @ObservedObject var vm: EditorViewModel
    
    var body: some View {
        if let processedImage = vm.processedImage {
            processedImage
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(vm.rotationAngle))
                .pinchToZoom()
            
        } else {
            PhotosPicker(selection: $vm.selectedItem) {
                ContentUnavailableView("Нет изображения", systemImage: "photo.badge.plus", description: Text("Нажмите чтобы выбрать изображение"))
                    .onChange(of: vm.selectedItem, vm.loadImage)
            }
        }
    }
}

#Preview {
    EditorProcessedImageUI(vm: EditorViewModel())
}
