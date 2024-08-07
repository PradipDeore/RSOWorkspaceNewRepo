//
//  PhoneCallUtility.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/08/24.
//

import Foundation
import UIKit

class PhoneCallUtility {
    /// - Parameter phoneNumber: The phone number to call.
        static func makePhoneCall(phoneNumber: String) {
            let formattedNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
            if let phoneURL = URL(string: "tel://\(formattedNumber)"),
               UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                showAlertCannotMakeCall()
            }
        }
        
        /// Shows an alert if the device cannot make a phone call.
        private static func showAlertCannotMakeCall() {
            if let viewController = UIApplication.shared.keyWindow?.rootViewController {
                let alert = UIAlertController(title: "Error", message: "Your device cannot make phone calls.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
            }
        }
}
