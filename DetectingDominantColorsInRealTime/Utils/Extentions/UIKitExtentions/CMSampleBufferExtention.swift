

import Foundation
import AVFoundation
import UIKit
extension CMSampleBuffer {
    
    
    func convertToUImage() -> UIImage {
        
        var liveImage = UIImage()
        let pixelBuffer = CMSampleBufferGetImageBuffer(self)
       
        guard let pixelBuffer = pixelBuffer else {return liveImage}
        
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        let context = CIContext()
        
        let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
        
            
        if let image = context.createCGImage(cameraImage, from: imageRect, format: .RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB()) {
            
            liveImage =  UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .down)
            

        }
        
        return liveImage
    }
}
