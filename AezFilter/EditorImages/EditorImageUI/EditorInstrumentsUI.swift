//
//  EditorInstrumentsUI.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 09.05.24.
//

import SwiftUI

struct EditorInstrumentsUI: View {
    @ObservedObject var vm: EditorViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                withAnimation {
                    vm.rotateImage(angle: "Left")
                }
            }) {
                Image(systemName: "arrow.uturn.backward.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            Button(action: {
                withAnimation {
                    vm.rotateImage(angle: "Right")
                }
            }) {
                Image(systemName: "arrow.uturn.forward.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            Slider(value: $vm.filterIntensity)
                .onChange(of: vm.filterIntensity, vm.applyProcessing)
        }
        .padding(.horizontal)
    }
}

#Preview {
    EditorInstrumentsUI(vm: EditorViewModel())
}
