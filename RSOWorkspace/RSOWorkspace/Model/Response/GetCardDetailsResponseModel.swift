//
//  GetCardDetailsResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/08/24.
//

import Foundation

struct GetCardDetailsResponseModel: Codable {
    let status: String?
    let data: [GetCardDetails]?
}

// MARK: - GetCardDetails
struct GetCardDetails: Codable {
    let id, memberID: Int?
    let number, expiry: String?
    let cardHolderName, cardType, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case memberID = "member_id"
        case number, expiry
        case cardHolderName = "card_holder_name"
        case cardType = "card_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
