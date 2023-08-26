//
//  ColorRecognizerViewModel.swift
//  ColorSense
//
//  Created by jonata klabunde on 19/08/23.
//

import AVFoundation
import SwiftUI


final class ColorRecognizerViewModel: ObservableObject {
    
    let camera = Camera()
    @Published var image: Image?
    @Published var color: Color = .white
    @Published var colorName: String = ""
    
    
    
    init() {
        /// camera
        Task {
            await handleCameraPreviews()
        }
    }
    
    func sayTheName() {
        feedbackImpact(.heavy)
        Speaker.shared.say("Cor \(self.colorName)")
    }
    
    
    func voiceCommand() {
        
    }
    

}

// MARK:  Private
extension ColorRecognizerViewModel {
    
    func handleCameraPreviews() async {
        let imageStream = camera.previewStream.map { $0 }
        for await ciImage in imageStream {
            Task { @MainActor in
                /// image
                self.image = ciImage.toImage
                if let color = ciImage.centralPixelColor {
                    /// color
                    self.color = Color(color)
                    /// name
                    self.colorName = color.name()!
                }
            }
        }
    }
    
}
