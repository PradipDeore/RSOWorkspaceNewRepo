//
//  String.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/03/24.
//

import Foundation
extension String {
    var integerValue: Int? {
        // Removing the decimal part
        if let dotRange = self.range(of: ".") {
            let integerPart = self[..<dotRange.lowerBound]
            
            // Converting the integer part to an integer
            return Int(integerPart)
        } else {
            // If there's no decimal part, directly convert the whole string to an integer
            return Int(self)
        }
    }
}

// Usage:
//let roomPriceString = "100.00"
//if let roomPriceInt = roomPriceString.roomPriceInt {
//    print("Room price as integer: \(roomPriceInt)")
//} else {
//    print("Failed to convert room price to integer")
//}
extension String {
    func monthName() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else { return nil }
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        return monthFormatter.string(from: date)
    }
    
    func day() -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else { return nil }
        
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }
   

}

//usage
//let dateString = "2024-02-01"
//if let monthName = dateString.monthName(),
//   let day = dateString.day() {
//    print("Month Name: \(monthName)")
//    print("Day: \(day)")
//} else {
//    print("Invalid date format")
//}
