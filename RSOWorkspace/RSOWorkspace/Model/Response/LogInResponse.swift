//
//  LogInSignUp.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/02/24.
//

import Foundation


// MARK: - Welcome
struct LogInSuccessResponse: Codable {
  let status: Bool?
  let token: String?
  let data: UserData?
  let companyUser: Bool?
  let message: String?
  let isGuest: Bool?
  
  enum CodingKeys: String, CodingKey {
    case status, token, data,message
    case companyUser = "company-user"
    case isGuest = "is_guest"
  }
}

// MARK: - DataClass
struct UserData: Codable {
    let id: Int
    let firstName, lastName: String?
    let email: String?
    let companyID, designation: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case companyID = "company_id"
        case designation, status
    }
}
