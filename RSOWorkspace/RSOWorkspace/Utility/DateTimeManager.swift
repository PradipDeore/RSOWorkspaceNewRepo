//
//  DateTimeManager.swift
//  RSOWorkspace
//
//  Created by Pradip on 13/09/24.
//

import Foundation

struct DateTimeSelection {
    var selectedDate: Date?
    var startTime: Date?
    var endTime: Date?
}

class DateTimeManager {
    static let shared = DateTimeManager()
    //var eightThirtyAM: Date = Date()
   // var fiveThirtyPM: Date = Date()
    var tenPM: Date = Date()
    var nineAM: Date = Date()
    var sixPM: Date = Date()
    private init() {
        //eightThirtyAM = getTime(hour: 8, minute: 30)
        //fiveThirtyPM = getTime(hour: 17, minute: 30)
        tenPM = getTime(hour: 22, minute: 00)
        nineAM = getTime(hour: 9, minute: 00)
        sixPM = getTime(hour: 18, minute: 00)
    }
    // Properties to store selected values
    private var dateTimeSelection = DateTimeSelection()

    // Getter and Setter for selected date
    func setSelectedDate(_ date: Date) {
        dateTimeSelection.selectedDate = date
    }
    
    func getSelectedDate() -> Date? {
        return dateTimeSelection.selectedDate
    }
    
    // Getter and Setter for start time
    func setStartTime(_ time: Date) {
        dateTimeSelection.startTime = time
    }
    
    func getStartTime() -> Date? {
        return dateTimeSelection.startTime
    }
    
    // Getter and Setter for end time
    func setEndTime(_ time: Date) {
        dateTimeSelection.endTime = time
    }
    
    func getEndTime() -> Date? {
        return dateTimeSelection.endTime
    }
    
    // Function to check if current time has passed for the start time
    func isCurrentTimePassedForStartTime() -> Bool {
        guard let selectedDate = dateTimeSelection.selectedDate,
              let startTime = dateTimeSelection.startTime else {
            return false
        }
        
        return isCurrentTimePassed(for: selectedDate, selectedTime: startTime)
    }
    
    // Function to check if current time has passed for the end time
    func isCurrentTimePassedForEndTime() -> Bool {
//        guard let selectedDate = dateTimeSelection.selectedDate,
//              let endTime = dateTimeSelection.endTime else {
//            return false
//        }
        guard let selectedDate = dateTimeSelection.selectedDate
               else { return false }
        // Use tenPM directly since it's not optional
           let endTime = DateTimeManager.shared.tenPM
        //return isCurrentTimePassed(for: selectedDate, selectedTime: endTime)
        return isCurrentTimePassed(for: selectedDate, selectedTime: endTime)
    }
    func isTimePassedForEndTime(againstDate: Date) -> Bool {
        guard let selectedDate = dateTimeSelection.selectedDate,
              let endTime = dateTimeSelection.endTime else {
            return false
        }
        return isTimePassed(for: selectedDate, selectedTime: endTime, againstDate: againstDate)
    }

    func isDateToday() -> Bool {
        guard let selectedDate = dateTimeSelection.selectedDate else {
            return false
        }
        let calendar = Calendar.current
        return calendar.isDateInToday(selectedDate)
    }
    
    func areDatesSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }

    func isSelectedDateSametoDate(givenDate: Date) -> Bool {
        if let selDate = getSelectedDate() {
            let calendar = Calendar.current
            return calendar.isDate(selDate, inSameDayAs: givenDate)
        }
        return false
    }
    
    // Utility function to merge date and time and compare with current time
    private func isCurrentTimePassed(for selectedDate: Date, selectedTime: Date) -> Bool {
        return self.isTimePassed(for: selectedDate, selectedTime: selectedTime)
    }
    private func isTimePassed(for selectedDate: Date, selectedTime: Date, againstDate: Date = Date()) -> Bool {
        let calendar = Calendar.current
        let selectedDateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let selectedTimeComponents = calendar.dateComponents([.hour, .minute, .second], from: selectedTime)
        
        var mergedComponents = DateComponents()
        mergedComponents.year = selectedDateComponents.year
        mergedComponents.month = selectedDateComponents.month
        mergedComponents.day = selectedDateComponents.day
        mergedComponents.hour = selectedTimeComponents.hour
        mergedComponents.minute = selectedTimeComponents.minute
        mergedComponents.second = selectedTimeComponents.second
        
        if let mergedDate = calendar.date(from: mergedComponents) {
            return mergedDate <= againstDate
        }
        
        return false
    }
    private func getTime(hour: Int, minute: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)!
    }
}

