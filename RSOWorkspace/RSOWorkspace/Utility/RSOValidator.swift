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
        // Ensure the phone number has a maximum length of 14 digits
        return phoneNumber.count <= 14 && phoneNumber.allSatisfy { $0.isNumber }
    }



}
