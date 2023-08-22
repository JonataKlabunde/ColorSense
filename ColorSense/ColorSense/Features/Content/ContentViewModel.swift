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
    
    func sayTheName() {
        feedbackImpact(.heavy)
        
        print("ios - \(self.color)")
    }
}


fileprivate extension CIImage {
    var toImage: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

fileprivate extension UIColor {
    func name() -> String? {
        let colorList: [String: UIColor] = [
            "Branco": UIColor.white,
            "Vermelho": UIColor.red,
            "Verde": UIColor.green,
            "Azul": UIColor.blue,
            "Amarelo": UIColor.yellow,
            "Laranja": UIColor.orange,
            "Roxo": UIColor.purple,
            "Marrom": UIColor.brown,
            "Cinza": UIColor.gray,
            "Rosa": UIColor.systemPink,
            "Menta": UIColor.systemMint,
            "Ciano": UIColor.cyan,
            "Magenta": UIColor.magenta,
            "Creme": UIColor(displayP3Red: 255.0/255, green: 253.0/255, blue: 208.0/255, alpha: 1.0),
            "Pêssego": UIColor(displayP3Red: 255.0/255, green: 218.0/255, blue: 185.0/255, alpha: 1.0),
            "Lavanda": UIColor(displayP3Red: 230.0/255, green: 230.0/255, blue: 250.0/255, alpha: 1.0),
            "Limão": UIColor(displayP3Red: 255.0/255, green: 250.0/255, blue: 205.0/255, alpha: 1.0),
            "Turquesa": UIColor(displayP3Red: 64.0/255, green: 224.0/255, blue: 208.0/255, alpha: 1.0),
            "Ouro": UIColor(displayP3Red: 255.0/255, green: 215.0/255, blue: 0.0/255, alpha: 1.0),
            "Prata": UIColor(displayP3Red: 192.0/255, green: 192.0/255, blue: 192.0/255, alpha: 1.0)
        ]
        
        var minDistance = Double.infinity
        var closestColorName: String?

        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)

        for (name, color) in colorList {
            var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
            color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

            let distance = pow(Double(r1 - r2), 2) + pow(Double(g1 - g2), 2) + pow(Double(b1 - b2), 2)

            if distance < minDistance {
                minDistance = distance
                closestColorName = name
            }
        }

        return closestColorName
    }
}
