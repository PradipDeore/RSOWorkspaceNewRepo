//
//  RSOValidator.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 19/02/24.
//

import Foundation
class RSOValidator{
    class func isValidName(_ name: String) -> Bool {
        let nameRegex = "^[a-zA-Z ]*$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: name)
    }
        class func isValidEmail(_ email: String) -> Bool {
            // Trim the email string to remove leading and trailing spaces
               let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
               
               // Regular expression pattern for email validation
               let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
               
               let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
               return emailPredicate.evaluate(with: trimmedEmail)
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
    
    class func isValidCardNumber(_ number: String) -> Bool {
        // Remove spaces and dashes
        let cleanNumber = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        // Check length
        if cleanNumber.count < 16 || cleanNumber.count > 19 {
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
    class func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        // Define regular expression patterns for valid phone numbers
        let indianPhoneNumberPattern = "^[6-9]\\d{9}$" // Indian numbers start with 6-9 and are 10 digits long
        let dubaiPhoneNumberPattern = "^(?:\\+971|971)?[5-9]\\d{8}$" // Dubai numbers can start with +971 or 971 and are 9 digits long
        
        // Check if the phone number matches either pattern
        let isIndianNumber = NSPredicate(format: "SELF MATCHES %@", indianPhoneNumberPattern).evaluate(with: phoneNumber)
        let isDubaiNumber = NSPredicate(format: "SELF MATCHES %@", dubaiPhoneNumberPattern).evaluate(with: phoneNumber)
        
        return isIndianNumber || isDubaiNumber
    }
    class func validateDubaiPhoneNumber(_ phoneNumber: String) -> Bool {
        // Define the regular expression pattern for valid Dubai phone numbers
        // Dubai numbers must start with +971 or 971, followed by 9 digits (for mobile numbers)
        let dubaiPhoneNumberPattern = "^(\\+971|971)?5[0245689]\\d{7}$" // Dubai mobile numbers starting with +971 or 971, followed by 50, 52, 54, etc.

        // Check if the phone number matches the Dubai phone number pattern
        let isDubaiNumber = NSPredicate(format: "SELF MATCHES %@", dubaiPhoneNumberPattern).evaluate(with: phoneNumber)
        
        return isDubaiNumber
    }


}
