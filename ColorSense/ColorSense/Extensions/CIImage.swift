//
//  UIImage.swift
//  ColorSense
//
//  Created by jonata klabunde on 19/08/23.
//

import SwiftUI

extension CIImage {
    
    var averageColor: UIColor? {
        let inputImage = self
        let extentVector = CIVector(
            x: inputImage.extent.origin.x,
            y: inputImage.extent.origin.y,
            z: inputImage.extent.size.width,
            w: inputImage.extent.size.height
        )
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        
        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: nil
        )
        
        return UIColor(
            red: CGFloat(bitmap[0]) / 255,
            green: CGFloat(bitmap[1]) / 255,
            blue: CGFloat(bitmap[2]) / 255,
            alpha: CGFloat(bitmap[3]) / 255
        )
    }
    
    
    var centralPixelColor: UIColor? {
        let context = CIContext(options: nil)
        let centralPoint = CGPoint(x: extent.size.width / 2, y: extent.size.height / 2)
        let centralRect = CGRect(x: centralPoint.x, y: centralPoint.y, width: 1, height: 1)

        var pixel: [UInt8] = [0, 0, 0, 0]
        
        context.render(self,
                       toBitmap: &pixel,
                       rowBytes: 4,
                       bounds: centralRect,
                       format: .RGBA8,
                       colorSpace: CGColorSpace(name: CGColorSpace.sRGB))

        let red = CGFloat(pixel[0]) / 255.0
        let green = CGFloat(pixel[1]) / 255.0
        let blue = CGFloat(pixel[2]) / 255.0
        let alpha = CGFloat(pixel[3]) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}


extension CIImage {
    var toImage: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}
