//
//  ContentViewModel.swift
//  ColorSense
//
//  Created by jonata klabunde on 19/08/23.
//

import SwiftUI

final class ContentViewModel: ObservableObject {
    
    let camera = Camera()
    @Published var viewfinderImage: Image?
    @Published var colorName: String = "Preto"
    
    init() {
        Task {
            await handleCameraPreviews()
        }
    }
    
    func handleCameraPreviews() async {
        let imageStream = camera.previewStream.map { $0.image }
        for await image in imageStream {
            Task { @MainActor in
                viewfinderImage = image
            }
        }
    }
    
    func sayTheName() {
        feedbackImpact(.heavy)
    }
}


fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}
