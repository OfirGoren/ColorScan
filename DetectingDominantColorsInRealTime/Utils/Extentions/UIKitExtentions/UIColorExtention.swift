
import Foundation
import UIKit
extension UIColor {
    
    convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = 1) {
        self.init(
            red: CGFloat(red)/255,
            green: CGFloat(green)/255,
            blue: CGFloat(blue)/255,
            alpha: CGFloat(alpha))
    }
    
    
}
