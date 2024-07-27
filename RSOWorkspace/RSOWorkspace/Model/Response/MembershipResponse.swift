//
//  MembershipResponse.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 27/07/24.

import Foundation

// MARK: - Welcome
struct MembershipResponse: Codable {
    let status: Bool?
    let data: [MembershipData]?
}

// MARK: - Datum
struct MembershipData: Codable {
    let id: Int?
    let name: String?
    let orderBy: String?
    let services: [String]?
    let price: [PlanPrice]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case orderBy = "order_by"
        case services, price
    }
}

// MARK: - Price
struct PlanPrice: Codable {
    let price: String?
    let duration: String?
    let length: Int?
}
