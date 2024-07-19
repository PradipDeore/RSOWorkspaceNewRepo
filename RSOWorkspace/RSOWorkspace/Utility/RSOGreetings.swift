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
      var msg = ""
        if hour >= 6 && hour < 12 {
          msg = "Good Morning"
        } else if hour >= 12 && hour < 18 {
          msg = "Good Afternoon"
        } else {
          msg = "Good Evening"
        }
      if let name = UserHelper.shared.getUserFirstName() {
        msg = msg + " " + name
      }
      return msg
    }
}

