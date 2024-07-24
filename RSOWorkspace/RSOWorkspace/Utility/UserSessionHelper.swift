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
  private let userCompanyIDKey = "userCompanyID"
  private let userDesignationKey = "userDesignation"
  private let userStatusKey = "userStatus"
  private let userIsGuestKey = "userIsGuest"

  func saveUser(_ user: UserData) {
    userDefaults.set(user.id, forKey: customerIdKey)
    userDefaults.set(user.firstName, forKey: firstNameKey)
    userDefaults.set(user.lastName, forKey: lastNameKey)
    userDefaults.set(user.email, forKey: userEmailKey)
    userDefaults.set(user.companyID, forKey: userCompanyIDKey)
    userDefaults.set(user.designation, forKey: userDesignationKey)
    userDefaults.set(user.status, forKey: userStatusKey)
  }
  func saveUserIsGuest(_ isGuest: Bool) {
    userDefaults.set(isGuest, forKey: userIsGuestKey)
  }
  
  func isGuest() -> Bool {
    return userDefaults.bool(forKey: userIsGuestKey)
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
  
  func clearUser() {
    userDefaults.removeObject(forKey: customerIdKey)
    userDefaults.removeObject(forKey: firstNameKey)
    userDefaults.removeObject(forKey: lastNameKey)
    userDefaults.removeObject(forKey: userEmailKey)
    userDefaults.removeObject(forKey: userCompanyIDKey)
    userDefaults.removeObject(forKey: userDesignationKey)
    userDefaults.removeObject(forKey: userStatusKey)
    userDefaults.removeObject(forKey: userIsGuestKey)
    userDefaults.synchronize()
  }
}
