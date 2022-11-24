//
//  DictionaryExtention.swift
//  IdentifyingColorsInSpace
//
//  Created by Ofir Goren on 22/11/2022.
//

import Foundation
import UIKit

extension Dictionary {
    
    mutating func changeKey(from: Key, to: Key) {
        self[to] = self[from]
        self.removeValue(forKey: from)
    }
}
