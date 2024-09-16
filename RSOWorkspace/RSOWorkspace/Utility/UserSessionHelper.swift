//
//  UserSessionHelper.swift
//  NewGulfPharmacy
//
//  Created by Sumit Aquil on 20/06/24.
//

import Foundation


class UserHelper {
    
    static let shared = UserHelper()
    
    private init() { }
    
    private let userDefaults = UserDefaults.standard
    
    private let customerIdKey = "customerId"
    private let firstNameKey = "userFirstName"
    private let lastNameKey = "userLastName"
    private let userEmailKey = "userEmail"
    private let userPhotoKey = "userPhoto"
    private let userCompanyIDKey = "userCompanyID"
    private let userDesignationKey = "userDesignation"
    private let userStatusKey = "userStatus"
    private let userIsGuestKey = "userIsGuest"
    private let userIsLoggedIn = "userIsLoggedIn"
    private let notificationCountKey = "notifficationCount"
    private let userSelectedDateKey = "userSelectedDate"
    private let selectedStartTime = "userSelectedStartTime"
    private let selectedEndTime = "userSelectedEndTime"
    // New keys for social login
        private let isSocialLoginUserKey = "isSocialLoginUser"
    
    func saveUser(_ user: UserData) {
        userDefaults.set(user.id, forKey: customerIdKey)
        userDefaults.set(user.firstName, forKey: firstNameKey)
        userDefaults.set(user.lastName, forKey: lastNameKey)
        userDefaults.set(user.email, forKey: userEmailKey)
        userDefaults.set(user.companyID, forKey: userCompanyIDKey)
        userDefaults.set(user.designation, forKey: userDesignationKey)
        userDefaults.set(user.status, forKey: userStatusKey)
        userDefaults.set(true, forKey: userIsLoggedIn)
        saveSocialLoginUser(false)  // Set the social login flag to false (normal login)

    }
    func saveSelectedDateByuser(_ selectedDate: Date){
        let selectedDateString = selectedDate.stringFromDate(format: .yyyyMMdd)
        userDefaults.set(selectedDateString , forKey: userSelectedDateKey)
        
    }
    
    func getSelectedMonthAndDay() -> [Int] {
        let defaultDate = Date() // Use today's date as a fallback
        let calendar = Calendar.current
        
        // Safely unwrap the optional string and date using guard let
        if let dateString = userDefaults.string(forKey: userSelectedDateKey),
           let selectedDate = Date.dateFromString(dateString, format: .yyyyMMdd) {
            print("Selected date: \(selectedDate)")
            
            // Extract month and day components from the selected date
            let selectedMonth = calendar.component(.month, from: selectedDate)
            let selectedDay = calendar.component(.day, from: selectedDate)
            return [selectedMonth, selectedDay] // Return month and day as an array
        } else {
            // Use the default date if no selected date is found
            let defaultMonth = calendar.component(.month, from: defaultDate)
            let defaultDay = calendar.component(.day, from: defaultDate)
            print("Date not found or format is incorrect, using default date")
            return [defaultMonth, defaultDay] // Return default month and day as an array
        }
    }

    func saveSelectedTimes(startTime: Date, endTime: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // ISO 8601 format
        
        let startTimeString = formatter.string(from: startTime)
        let endTimeString = formatter.string(from: endTime)
        
        // Save to UserDefaults
        UserDefaults.standard.set(startTimeString, forKey: "startTime")
        UserDefaults.standard.set(endTimeString, forKey: "endTime")
        
        // Optionally synchronize to ensure data is saved immediately
        UserDefaults.standard.synchronize()
    }
    func getSavedStartTime() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // Same format used for saving
        
        if let startTimeString = UserDefaults.standard.string(forKey: "startTime") {
            return formatter.date(from: startTimeString)
        }
        return nil // Return nil if no saved start time
    }

    func getSavedEndTime() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // Same format used for saving
        
        if let endTimeString = UserDefaults.standard.string(forKey: "endTime") {
            return formatter.date(from: endTimeString)
        }
        return nil // Return nil if no saved end time
    }


    // Save a flag to indicate whether the user logged in via social login
        func saveSocialLoginUser(_ isSocialLogin: Bool) {
            userDefaults.set(isSocialLogin, forKey: isSocialLoginUserKey)
        }
        
        // Check if the user is a social login user
        func isSocialLoginUser() -> Bool {
            return userDefaults.bool(forKey: isSocialLoginUserKey)
        }
    func saveSocialuser(name:String, email:String){
        
        let namelist = name.components(separatedBy: " ")
        if namelist.count > 1 {
            userDefaults.set(namelist[0], forKey: firstNameKey)
            userDefaults.set(namelist[1], forKey: lastNameKey)
        }else{
            userDefaults.set(name, forKey: firstNameKey)
        }
        userDefaults.set(email, forKey: userEmailKey)
        userDefaults.set(true, forKey: userIsLoggedIn)
        saveSocialLoginUser(true)  // Set the social login flag to true
    }
    
    func saveUserIsGuest(_ isGuest: Bool) {
        userDefaults.set(isGuest, forKey: userIsGuestKey)
    }
    
    func isGuest() -> Bool {
        if isUserExplorer() {
            return true
        }
        return userDefaults.bool(forKey: userIsGuestKey)
    }
    func isUserExplorer() -> Bool {
        return !userDefaults.bool(forKey: userIsLoggedIn)
    }
    func saveUserIsExplorer(_ isExplorer: Bool) {
        userDefaults.set(isExplorer, forKey: userIsLoggedIn)
    }
    
    func getUserId() -> Int? {
        return userDefaults.integer(forKey: customerIdKey)
    }
    func getUserFirstName() -> String? {
        return userDefaults.string(forKey: firstNameKey)
    }
    func getFullname() -> String? {
        var firstName = ""
        var lastName = ""
        if let fName = getUserFirstName() {
            firstName =  fName
        }
        if let lName = getUserLastName() {
            lastName = lName
        }
        
        let name = firstName + " " + lastName
        return name
    }
    func getUserLastName() -> String? {
        return userDefaults.string(forKey: lastNameKey)
    }
    func saveUserFirstName(firstName: String?) {
        return userDefaults.setValue(firstName, forKey: firstNameKey)
    }
    
    func saveUserLastName(lastName: String?) {
        return userDefaults.setValue(lastName, forKey: lastNameKey)
    }
    //    func saveUserPhoto(userphoto: String) -> String?{
    //        return userDefaults.setValue(userphoto, forKey: userPhotoKey)
    //    }
    
    func getUserEmail() -> String? {
        return userDefaults.string(forKey: userEmailKey)
    }
    
    func getUserCompanyID() -> String? {
        return userDefaults.string(forKey: userCompanyIDKey)
    }
    
    func getUserDesignation() -> String? {
        return userDefaults.string(forKey: userDesignationKey)
    }
    func saveUserDesignation(designation: String?) {
        return userDefaults.setValue(designation, forKey: userDesignationKey)
    }
    
    func getUserStatus() -> String? {
        return userDefaults.string(forKey: userStatusKey)
    }
    func getUserPhoto() -> String? {
        return userDefaults.string(forKey: userPhotoKey)
    }
    
    func saveNotificationCount(notificationCount: Int?) {
        guard let count = notificationCount else {
            print("Notification count is nil, not saving.")
            return
        }
        print("Saving notification count: \(count)")
        userDefaults.set(count, forKey: notificationCountKey)
    }
    
    func getNotificationCount() -> Int? {
        // Check if the key exists in UserDefaults
        if userDefaults.object(forKey: notificationCountKey) == nil {
            return nil
        }
        // Retrieve the stored integer value
        return userDefaults.integer(forKey: notificationCountKey)
    }
    
    
    func clearUser() {
        userDefaults.removeObject(forKey: customerIdKey)
        userDefaults.removeObject(forKey: firstNameKey)
        userDefaults.removeObject(forKey: lastNameKey)
        userDefaults.removeObject(forKey: userEmailKey)
        userDefaults.removeObject(forKey: userCompanyIDKey)
        userDefaults.removeObject(forKey: userDesignationKey)
        userDefaults.removeObject(forKey: userStatusKey)
        userDefaults.removeObject(forKey: userIsGuestKey)
        userDefaults.removeObject(forKey: userIsLoggedIn)
        userDefaults.removeObject(forKey: isSocialLoginUserKey)  // Remove social login flag
        userDefaults.synchronize()
    }
}
