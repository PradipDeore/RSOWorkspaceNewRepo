//
//  Date.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 12/03/24.
//

import Foundation
enum RSODateFormat: String{
  case EEEEddMMMMyyyy = "EEEE dd MMMM yyyy"
  case yyyyMMdd = "yyyy-MM-dd"
  case HHmm = "HH:mm"
  case hhmma = "hh:mm a"
  case hhmmss = "hh:mm:ss"
  case HHmmss = "HH:mm:ss"
  case ddMMyyyy = "dd/MM/yyyy"
    case MMMM = "MMMM" // Full month name
    case yyyyMMddPlus = "yyyy-MM-dd HH:mm:ss"
}

extension Date {
  static func formatSelectedDate(format: RSODateFormat , date: Date?) -> String {
    // Create a DateFormatter instance
    let dateFormatter = DateFormatter()
    
    // Set the desired output date format
    dateFormatter.dateFormat = format.rawValue
    
    // Check if the date parameter is available
    if let inputDate = date {
      // Convert the parsed date to the desired format
      let formattedDate = dateFormatter.string(from: inputDate)
      print(formattedDate) // Output: Monday 14 March 2024
      return formattedDate
    } else {
      // Get the current date if the date parameter is not available
      let currentDate = Date()
      let formattedDate = dateFormatter.string(from: currentDate)
      print(formattedDate) // Output: Monday 14 March 2024
      return formattedDate
    }
    
  }
  
  static func dateFromString(_ dateString: String, format: RSODateFormat) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format.rawValue
    return dateFormatter.date(from: dateString)
  }
  static func convertTo(_ dateString: String, givenFormat: RSODateFormat, newFormat:RSODateFormat) -> String? {
    let date = Date.dateFromString(dateString, format: givenFormat)
    let dateString = Date.formatSelectedDate(format: newFormat, date: date)
    return dateString
  }
  
  func stringFromDate(format: RSODateFormat) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format.rawValue
    return dateFormatter.string(from: self)
  }
  
  static func formattedDayAndMonth(from dateString: String) -> (dayName: String, dateMonth: String)? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    guard let currentDate = dateFormatter.date(from: dateString) else {
      return nil // Return nil if unable to parse the date
    }
    
    let dayDateFormatter = DateFormatter()
    dayDateFormatter.dateFormat = "EEEE" // Full day name format
    let dayName = dayDateFormatter.string(from: currentDate)
    
    let displayDateFormatter = DateFormatter()
    displayDateFormatter.dateFormat = "dd/MMM" // Date format: day/month
    let dateMonth = displayDateFormatter.string(from: currentDate)
    
    return (dayName, dateMonth)
  }
  static func adding(to givenDate:Date, hours: Int) -> Date? {
    let calendar = Calendar.current
    return calendar.date(byAdding: .hour, value: hours, to: givenDate)
  }
  static func dateForGivenTime(hour: Int, minute: Int = 0, second: Int = 0) -> Date? {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day], from: Date())
    components.hour = hour
    components.minute = minute
    components.second = second
    return calendar.date(from: components)
  }
    // for sidemenu payment screen requst model
    /// Returns the current month as an integer.
        static func getCurrentMonth() -> Int {
            let currentDate = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.month], from: currentDate)
            return components.month ?? 0
        }
        
        /// Returns the current year as an integer.
        static func getCurrentYear() -> Int {
            let currentDate = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year], from: currentDate)
            return components.year ?? 0
        }
}

