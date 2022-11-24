

import Foundation
import UIKit

class DominantColorsHelper {
    
    
    static func getFiveMostDominantColorsInImage(for liveImage:UIImage) -> [DominantColor] {
        
        let imageColorsDic = sumColorsAccordingRGB(for: liveImage)
        
        let liveImagePixelHeight = liveImage.pixelHeight
        let liveImagePixelWidth = liveImage.pixelWidth
        
        return prepareFiveMostDominatColorsInImage(for: imageColorsDic, imagePixelHeight: liveImagePixelHeight, imagePixelWidth: liveImagePixelWidth)
        
    }
    
    
    private static func sumColorsAccordingRGB(for liveImage: UIImage)->[RGBColor : Int] {
        
        var sumColorsDic = [RGBColor : Int]()
        
        // Go through all the pixels
        for yCo in 0 ..< liveImage.pixelHeight{
            for xCo in 0 ..< liveImage.pixelWidth {
                // Get the RGB specific pixel
                let RGBPixel = liveImage.pixelColor(x: xCo, y: yCo)
                // update the amount (increase by one) according the RGB color
                updateAmountValueAccordingRGB(search: RGBPixel,  in: &sumColorsDic)
            }
            
        }
        return sumColorsDic
        
    }
    
    
    private static func updateAmountValueAccordingRGB(search RGBPixel:[UInt8], in sumColorsDic: inout [RGBColor : Int]) {
        let color = RGBColor(RColor: RGBPixel[0], GColor: RGBPixel[1], BColor: RGBPixel[2])
        // When RGB already exists
        if let result = sumColorsDic[color] {
            // Increase the value by one
            sumColorsDic[color] = result + 1
            
            // When RGB not exists
        }else {
            // Insert the objct with value one
            sumColorsDic[color] = 1
        }
        
    }
    
    
    
    private static func prepareFiveMostDominatColorsInImage(for colors:[RGBColor : Int],imagePixelHeight:Int,imagePixelWidth:Int )-> [DominantColor] {
        
        // Get the five most popular color
        let strongestFiveColrs = Array(colors.sorted{$0.value > $1.value}.prefix(5))
        
        var mStrongestFiveColrs = [DominantColor]()
        
        for (result) in strongestFiveColrs {
            // Get the color coverage area
            let colorCoveragePercentage = (Float(result.value)/(Float(imagePixelHeight) * Float(imagePixelWidth)))*100
            // prepre object data
            let colorDistribution = DominantColor(RGBcolor: result.key,colorCoveragePercentage: colorCoveragePercentage.rounded(toPlaces: 2))
            // insert
            mStrongestFiveColrs.append(colorDistribution)
            
            
        }
        return mStrongestFiveColrs
    }
}


