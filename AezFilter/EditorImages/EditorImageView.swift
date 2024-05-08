//
//  EditorImageView.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 06.05.24.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

enum PickerCases: String, CaseIterable, Identifiable  {
    case instruments = "Инструменты", filters = "Фильтры", export = "Экспорт"
    
    var id: String { self.rawValue }
}

struct EditorImageView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var selectedItem: PhotosPickerItem?
    @State private var rotationAngle: Double = 0.0
    @State private var resetFilterIntensity = false
    
    @State var lastScaleValue: CGFloat = 1.0
    @State private var scale: CGFloat = 1.0
    
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var whatPickerCase = PickerCases.filters
    
    var body: some View {
        
        VStack {
            HStack {
                Image(systemName: "gobackward.5.ar")
                    .resizable()
                    .frame(width: 22, height: 25)
                    .foregroundStyle(.accent)
                    .padding(.horizontal)
                    .onTapGesture {
                        resetFilterIntensity.toggle()
                        
                        if resetFilterIntensity {
                            filterIntensity = 0
                        } else {
                            filterIntensity = 0.5
                        }
                    }
                
                Spacer()
                
                Text("Редактор фото")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.accent)
                
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.accent)
                        .padding(.horizontal)
                        .onChange(of: selectedItem, preLoadImage)
                }
            }
            
            Spacer()
            
            if let processedImage {
                processedImage
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(rotationAngle))
                    .pinchToZoom()
                
            } else {
                PhotosPicker(selection: $selectedItem) {
                    ContentUnavailableView("Нет изображения", systemImage: "photo.badge.plus", description: Text("Нажмите чтобы выбрать изображение"))
                        .onChange(of: selectedItem, loadImage)
                }
            }
            
            
            Spacer()
            
            if let processedImage {
                Picker("Picker", selection: $whatPickerCase) {
                    ForEach(PickerCases.allCases) { value in
                        Text(value.rawValue.capitalized).tag(value)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                switch whatPickerCase {
                case .instruments:
                    HStack(spacing: 20) {
                        Button(action: {
                            withAnimation {
                                rotationAngle -= 90
                            }
                        }) {
                            Image(systemName: "arrow.uturn.backward.square.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        
                        Button(action: {
                            withAnimation {
                                rotationAngle += 90
                            }
                        }) {
                            Image(systemName: "arrow.uturn.right.square.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        
                        VStack {
                            Slider(value: $filterIntensity)
                                .onChange(of: filterIntensity, applyProcessing)
                            
                            Text("Интенсивность эффекта")
                                .foregroundStyle(.accent)
                        }
                    }
                    .frame(height: 150)
                    
                case .export:
                    ShareLink(item: processedImage, preview: SharePreview("AezFilter изображение", image: processedImage)) {
                        VStack {
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .frame(width: 30, height: 40)
                            Text("Экспорт")
                        }
                        .frame(height: 150)
                    }
                    
                    
                case .filters:
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 22) {
                            FilterExampleUI("Сепия", "FilterSepia") { setFilter(CIFilter.sepiaTone()) }
                            FilterExampleUI("Контраст", "FilterContrast") { setFilter(CIFilter.unsharpMask()) }
                            FilterExampleUI("Виньетка", "FilterVignetting") { setFilter(CIFilter.vignette()) }
                            FilterExampleUI("Размытие", "FilterBlur") { setFilter(CIFilter.gaussianBlur()) }
                            FilterExampleUI("Пиксели", "FilterPixels") { setFilter(CIFilter.pixellate()) }
                            FilterExampleUI("Кристал", "FilterCrystal") { setFilter(CIFilter.crystallize()) }
                            FilterExampleUI("Контуры", "FilterLines") { setFilter(CIFilter.edges()) }
                        }
                        .frame(height: 150)
                    }
                }
            }
        }
        .padding(.horizontal)
        .navigationTitle("Редактор фото")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    // MARK: - Functions
    func preLoadImage() {
        rotationAngle = 0.0
        loadImage()
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
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
    
    // MARK: - Function for counting the number of times filters have been used before the review is show
    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        filterCount += 1
        
        if filterCount == 7 {
            requestReview()
        }
    }
}

#Preview {
    EditorImageView()
}
