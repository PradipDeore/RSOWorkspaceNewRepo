//
//  OfficeItems.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/04/24.
//

import Foundation
struct OfficeItemsResponse: Codable {
    let status: Bool
    let data: [Office]
}

struct Office: Codable {
    let id: Int
    let name: String
    let image: String
    let capacity: Int
    let price: String
    let type: String
    let amenityDetails: [AmenityDetail]

    enum CodingKeys: String, CodingKey {
        case id, name, image, capacity, price, type
        case amenityDetails = "amenity_details"
    }
}

struct AmenityDetail: Codable {
    let amenityName: String

    enum CodingKeys: String, CodingKey {
        case amenityName = "amenity_name"
    }
}

