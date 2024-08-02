//
//  PhoneCallUtility.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/08/24.
//

import Foundation
import UIKit

class PhoneCallUtility {
    static func makePhoneCall(to phoneNumber: String) {
        // Format the phone number to remove any unwanted characters
        let formattedNumber = phoneNumber.filter("0123456789".contains)
        
        // Create the phone URL
        if let phoneUrl = URL(string: "tel://\(formattedNumber)"),
           UIApplication.shared.canOpenURL(phoneUrl) {
            UIApplication.shared.open(phoneUrl, options: [:], completionHandler: nil)
        } else {
            // Handle the case where the device cannot make a call
            print("Cannot make a call from this device or the phone number is invalid")
        }
    }
}
