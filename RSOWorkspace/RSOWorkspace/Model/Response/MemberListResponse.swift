//
//  MemberListResponse.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 26/03/24.
//

import Foundation

struct Member: Codable {
    let id: Int
    let firstName: String?
    let lastName: String?
    let phone: String?
    let email: String?
    let photo: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
        case email
        case photo
    }
   
}

struct MemberListResponse: Codable {
    let status: Bool
    let data: [Member]
}
