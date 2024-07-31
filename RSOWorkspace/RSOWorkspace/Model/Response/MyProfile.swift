//
//  MyProfile.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/04/24.
//

import Foundation
struct MyProfile: Codable {
    let status: Bool
    let data: ProfileData
}

struct ProfileData: Codable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let phone: String?
    var photo :String?
    let designation: String?
    let rewardPoints: Int?
    let membershipName: String?
    let desc: String?
    let companyName: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phone
        case photo
        case designation
        case rewardPoints = "reward_points"
        case membershipName = "membership_name"
        case desc
        case companyName = "company_name"
    }
}

