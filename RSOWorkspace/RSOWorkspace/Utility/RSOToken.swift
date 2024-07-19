//
//  RSOToken.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 22/02/24.
//

import Foundation
class RSOToken {
  static var shared = RSOToken()
  private let userDefaults = UserDefaults.standard
  private let tokenKey = "Token"
  
  private init() {
  }
  func save(token:String){
    userDefaults.setValue(token, forKey: tokenKey)
  }
  func getToken()-> String?{
    let token = userDefaults.string(forKey: tokenKey)
    print("token is \(String(describing: token))")
    return token
  }
  func isLoggedIn()-> Bool {
   let result = (userDefaults.string(forKey: tokenKey) != nil)
    return result
  }
  func clearAll() {
    userDefaults.removeObject(forKey: tokenKey)
  }
}
