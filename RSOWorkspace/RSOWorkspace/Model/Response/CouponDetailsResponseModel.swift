//
//  CouponDetailsResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 24/07/24.
//

import Foundation

// MARK: - CouponDetailsResponseModel
struct CouponDetailsResponseModel: Codable {
    let status: Bool
    let data: [CouponDetails]
}

// MARK: - CouponDetails
struct CouponDetails: Codable {
    let id: Int
    let couponCode, couponDetails: String
    let rewardsPoints: Int
    let startDate, endDate: String
    let idDeleted: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case couponCode = "coupon_code"
        case couponDetails = "coupon_details"
        case rewardsPoints = "rewards_points"
        case startDate = "start_date"
        case endDate = "end_date"
        case idDeleted = "id_deleted"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
