//
//  EditorFiltersUI.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 09.05.24.
//

import SwiftUI

struct EditorFiltersUI: View {
    @ObservedObject var vm: EditorViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                FilterExampleUI("Сепия", "FilterSepia") { vm.setFilter(CIFilter.sepiaTone()) }
                FilterExampleUI("Контраст", "FilterContrast") { vm.setFilter(CIFilter.unsharpMask()) }
                FilterExampleUI("Виньетка", "FilterVignetting") { vm.setFilter(CIFilter.vignette()) }
                FilterExampleUI("Размытие", "FilterBlur") { vm.setFilter(CIFilter.gaussianBlur()) }
                FilterExampleUI("Пиксели", "FilterPixels") { vm.setFilter(CIFilter.pixellate()) }
                FilterExampleUI("Кристал", "FilterCrystal") { vm.setFilter(CIFilter.crystallize()) }
                FilterExampleUI("Контуры", "FilterLines") { vm.setFilter(CIFilter.edges()) }
            }
            .frame(height: 150)
            .padding(.horizontal)
        }
    }
}

#Preview {
    EditorFiltersUI(vm: EditorViewModel())
}
