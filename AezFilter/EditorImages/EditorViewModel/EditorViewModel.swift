//
//  EditorViewModel.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 09.05.24.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import SwiftUI


final class EditorViewModel: ObservableObject {
    // MARK: - Properties
    @Published var processedImage: Image?
    @Published var filterIntensity = 0.5
    @Published var selectedItem: PhotosPickerItem?
    @Published var rotationAngle: Double = 0.0
    @Published var resetFilterIntensity = false
    @Published var isShowAlert = false
    @Published var lastScaleValue: CGFloat = 1.0
    @Published var scale: CGFloat = 1.0
    @Published var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    // MARK: - Functions
    func preLoadImage() {
        rotationAngle = 0.0
        loadImage()
    }
    
    func rotateImage(angle: String) {
        if angle == "Left" {
            rotationAngle -= 90
        } else if angle == "Right" {
            rotationAngle += 90
        }
    }
    
    func clearImage() {
        processedImage = nil
        selectedItem = nil
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            DispatchQueue.main.async {
                self.applyProcessing()
            }
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}
