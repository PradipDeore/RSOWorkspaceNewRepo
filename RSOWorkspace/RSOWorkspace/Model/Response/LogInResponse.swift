//
//  LogInSignUp.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/02/24.
//

import Foundation
enum LogInResponse{
    case success(LogInSuccessResponse)
    case error (LogInErrorResponse)
}

struct LogInSuccessResponse: Codable {
    let status: Bool
    let token: String?
    let data: UserData?
    let companyUser: Bool?
    let message:String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case token
        case data
        case message
        case companyUser = "company-user"
    }
}

struct UserData: Codable {
    let id: Int
    let firstName: String?
    let lastName: String?
    let email: String
    let companyId: String?
    let designation: String?
    let status: String
}

struct LogInErrorResponse: Codable {
    let status: Bool
    let message: String
}
