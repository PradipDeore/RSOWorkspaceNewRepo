//
//  Double + Extension.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 07/09/24.
//

import Foundation


extension Double {
func toStringWithTwoDecimalPlaces() -> String {
    return String(format: "%.2f", self)
}
}

// Usage
//    let price: Double = 49.995
//    let formattedPrice = price.toStringWithTwoDecimalPlaces()
//    print(formattedPrice)  // Output: "50.00"
//
