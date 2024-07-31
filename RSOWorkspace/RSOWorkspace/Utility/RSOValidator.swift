//
//  RSOValidator.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 19/02/24.
//

import Foundation
class RSOValidator{
    class func isValidEmail(_ email: String) -> Bool {
        // Regular expression pattern for email validation
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    class func isValidPassword(_ password: String) -> Bool {
        // Password validation rules:
        // - At least 8 characters
        // - At least one uppercase letter
        // - At least one lowercase letter
        // - At least one digit
        let passwordRegex = "(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,}"

        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
   
    class func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        // Define a regular expression pattern for a valid phone number
        let phoneNumberPattern = "^[0-9]{10}$" // This pattern assumes a 10-digit phone number
        
        // Create a regular expression object using the pattern
        guard let regex = try? NSRegularExpression(pattern: phoneNumberPattern) else {
            return false // Return false if the regular expression pattern is invalid
        }
        
        // Perform matching using the regular expression
        let matches = regex.matches(in: phoneNumber, range: NSRange(location: 0, length: phoneNumber.utf16.count))
        
        // If there is at least one match, the phone number is valid
        return !matches.isEmpty
    }
    
    class func isValidCardNumber(_ number: String) -> Bool {
        // Remove spaces and dashes
        let cleanNumber = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        // Check length
        if cleanNumber.count < 13 || cleanNumber.count > 19 {
            return false
        }
        
        // Optional: Implement Luhn algorithm here if needed
        return true
    }

    class func isValidExpiryDate(_ date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        dateFormatter.isLenient = false
        
        guard let expiryDate = dateFormatter.date(from: date) else {
            return false
        }
        
        // Check if the expiry date is in the future
        return expiryDate > Date()
    }
}
