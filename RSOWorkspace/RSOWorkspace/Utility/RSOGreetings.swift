//
//  RSOGreetings.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/02/24.
//

import Foundation

class RSOGreetings {
    
    static func greetingForCurrentTime() -> String {
        // Get the current date
        let currentDate = Date()
        
        // Get the current hour using the Calendar class
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDate)
        
        // Determine the appropriate greeting based on the time of the day
        if hour >= 6 && hour < 12 {
            return "Good Morning"
        } else if hour >= 12 && hour < 18 {
            return "Good Afternoon"
        } else {
            return "Good Evening"
        }
    }
}

