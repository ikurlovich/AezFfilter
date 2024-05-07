//
//  ContentView.swift
//  AezFilter
//
//  Created by Ilia Kurlovich on 06.05.24.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var selectedItem: PhotosPickerItem?
    @State private var showingFilters = false
    @State private var rotationAngle: Double = 0.0
    @State private var resetFilterIntensity = false
    
    @State var lastScaleValue: CGFloat = 1.0
    @State private var scale: CGFloat = 1.0
    
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        
        VStack {
            HStack {
                Image(systemName: "gobackward.5.ar")
                    .resizable()
                    .bold()
                    .frame(width: 28, height: 30)
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
                        .bold()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.accent)
                        .padding(.horizontal)
                        .onChange(of: selectedItem, loadImage)
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
                HStack {
                    Button(action: {
                        withAnimation {
                            rotationAngle -= 90
                        }
                    }) {
                        Image(systemName: "arrow.uturn.backward.square.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .padding()
                    
                    Button(action: {
                        withAnimation {
                            rotationAngle += 90
                        }
                    }) {
                        Image(systemName: "arrow.uturn.right.square.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .padding()
                }
                
                HStack {
                    Text("Интенсивность")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity, applyProcessing)
                }
                
                HStack {
                    Button("Выбрать фильр", action: changeFilter)
                    
                    Spacer()
                    
                    
                    ShareLink(item: processedImage, preview: SharePreview("AezFilter изображение", image: processedImage))
                }
            }
        }
        .padding([.horizontal, .bottom])
        .navigationTitle("Редактор фото")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Select a filter", isPresented: $showingFilters) {
            Button("Кристализация") { setFilter(CIFilter.crystallize() )}
            Button("Контуры") { setFilter(CIFilter.edges() )}
            Button("Размытие") { setFilter(CIFilter.gaussianBlur() )}
            Button("Пикселизация") { setFilter(CIFilter.pixellate() )}
            Button("Сепия") { setFilter(CIFilter.sepiaTone() )}
            Button("Контраст") { setFilter(CIFilter.unsharpMask() )}
            Button("Виньетирование") { setFilter(CIFilter.vignette() )}
            Button("Отмена", role: .cancel) { }
        }
        
    }
    
    func changeFilter() {
        showingFilters = true
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
    ContentView()
}
