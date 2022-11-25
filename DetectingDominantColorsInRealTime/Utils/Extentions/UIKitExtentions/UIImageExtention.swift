import UIKit
import AVFoundation


/*
 Sources: https://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics/60247648#60247648
 
 explanation: I took the code because it was difficult to find information how to calculate the color of a pixel
 
 */



extension UIImage {
    
    var pixelWidth: Int {
        return cgImage?.width ?? 0
    }
    
    var pixelHeight: Int {
        return cgImage?.height ?? 0
    }
    
    
    /// Get specific pixel color (RGB color)
    /// - Parameters:
    ///   - x:Coordinate
    ///   - y:Coordinate
    /// - Returns: RGB colors,
    ///Array postions:
    /// 0 - R color,
    /// 1 - G color,
    /// 2 - B color
    
    func pixelColor(x: Int, y: Int) -> Array<UInt8> {
        assert(
            0..<pixelWidth ~= x && 0..<pixelHeight ~= y,
            "Pixel coordinates are out of bounds")
        
        guard
            let cgImage = cgImage,
            let data = cgImage.dataProvider?.data,
            let dataPtr = CFDataGetBytePtr(data),
            let colorSpaceModel = cgImage.colorSpace?.model,
            let componentLayout = cgImage.bitmapInfo.componentLayout
        else {
            assertionFailure("Could not get the color of a pixel in an image")
            return Array(repeating: 0, count: 4)
        }
        
        assert(
            colorSpaceModel == .rgb,
            "The only supported color space model is RGB")
        assert(
            cgImage.bitsPerPixel == 32 || cgImage.bitsPerPixel == 24,
            "A pixel is expected to be either 4 or 3 bytes in size")
        
        let bytesPerRow = cgImage.bytesPerRow
        let bytesPerPixel = cgImage.bitsPerPixel/8
        let pixelOffset = y*bytesPerRow + x*bytesPerPixel
        
        if componentLayout.count == 4 {
            let components = (
                dataPtr[pixelOffset + 0],
                dataPtr[pixelOffset + 1],
                dataPtr[pixelOffset + 2],
                dataPtr[pixelOffset + 3]
            )
            
            var alpha: UInt8 = 0
            var red: UInt8 = 0
            var green: UInt8 = 0
            var blue: UInt8 = 0
            switch componentLayout {
            case .rgba:
                alpha = components.3
                red = components.0
                green = components.1
                blue = components.2
            default:
                return Array(repeating: 0, count: 4)
            }
            
            // If chroma components are premultiplied by alpha and the alpha is `0`,
            // keep the chroma components to their current values.
            if cgImage.bitmapInfo.chromaIsPremultipliedByAlpha && alpha != 0 {
                let invUnitAlpha = 255/CGFloat(alpha)
                red = UInt8((CGFloat(red)*invUnitAlpha).rounded())
                green = UInt8((CGFloat(green)*invUnitAlpha).rounded())
                blue = UInt8((CGFloat(blue)*invUnitAlpha).rounded())
            }
            
            return [red,green,blue]
            
        } else if componentLayout.count == 3 {
            let components = (
                dataPtr[pixelOffset + 0],
                dataPtr[pixelOffset + 1],
                dataPtr[pixelOffset + 2]
            )
            
            var red: UInt8 = 0
            var green: UInt8 = 0
            var blue: UInt8 = 0
            
            switch componentLayout {
            case .rgb:
                red = components.0
                green = components.1
                blue = components.2
            default:
                return Array(repeating: 0, count: 4)
            }
            
            return  [red,green,blue,UInt8(255)]
            
        } else {
            assertionFailure("Unsupported number of pixel components")
            return Array(repeating: 0, count: 4)
        }
    }
    
    
    
    
    func renderResizedImage (newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        let image = renderer.image { (context) in
            self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        }
        return image
    }
    
}



