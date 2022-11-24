/*
  Sources: https://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics/60247648#60247648
 */
 

import Foundation
import UIKit

public extension CGBitmapInfo {

    enum ComponentLayout {
        
        case bgra
        case abgr
        case argb
        case rgba
        case bgr
        case rgb

        var count: Int {
            switch self {
            case .bgr, .rgb: return 3
            default: return 4
            }
        }
        
    }
    
    var componentLayout: ComponentLayout? {
        guard let alphaInfo = CGImageAlphaInfo(rawValue: rawValue & Self.alphaInfoMask.rawValue) else { return nil }
        let isLittleEndian = contains(.byteOrder32Little)

        if alphaInfo == .none {
            return isLittleEndian ? .bgr : .rgb
        }
        let alphaIsFirst = alphaInfo == .premultipliedFirst || alphaInfo == .first || alphaInfo == .noneSkipFirst

        if isLittleEndian {
            return alphaIsFirst ? .bgra : .abgr
        } else {
            return alphaIsFirst ? .argb : .rgba
        }
    }

    var chromaIsPremultipliedByAlpha: Bool {
        let alphaInfo = CGImageAlphaInfo(rawValue: rawValue & Self.alphaInfoMask.rawValue)
        return alphaInfo == .premultipliedFirst || alphaInfo == .premultipliedLast
    }

}
