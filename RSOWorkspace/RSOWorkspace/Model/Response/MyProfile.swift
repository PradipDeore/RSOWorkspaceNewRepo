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
    let membershipName, planLength, planType, monthlyAccessibleDays: String?
    let monthlyCost: String?
    let companyName: String?
    let qrCodeUrl:String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phone
        case photo
        case designation
        case rewardPoints = "reward_points"
        case membershipName = "membership_name"
        case planLength = "plan_length"
        case planType = "plan_type"
        case monthlyAccessibleDays = "monthly_accessible_days"
        case monthlyCost = "monthly_cost"
        case companyName = "company_name"
        case qrCodeUrl
    }
}

