//
//  DoubleExtention.swift
//  IdentifyingColorsInSpace
//
//  Created by Ofir Goren on 22/11/2022.
//

import Foundation


extension Float {
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
    
    
    
    
    ///Append at the end of the string
    func AddPercentageToString()->String {
        return "\(self)%"
        
    }
    
}
