//
//  ContentViewModel.swift
//  ColorSense
//
//  Created by jonata klabunde on 19/08/23.
//

import SwiftUI

final class ContentViewModel: ObservableObject {
    
    let camera = Camera()
    @Published var image: Image?
    @Published var color: Color = .clear
    @Published var colorName: String = "Preto"
    
    init() {
        Task {
            await handleCameraPreviews()
        }
    }
    
    func handleCameraPreviews() async {
        let imageStream = camera.previewStream.map { $0 }
        for await ciImage in imageStream {
            Task { @MainActor in
                self.image = ciImage.toImage
                if let averageColor = ciImage.averageColor {
                    self.color = Color(averageColor)
                }
            }
        }
    }
    
    func sayTheName() {
        feedbackImpact(.heavy)
    }
}


fileprivate extension CIImage {
    var toImage: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}
