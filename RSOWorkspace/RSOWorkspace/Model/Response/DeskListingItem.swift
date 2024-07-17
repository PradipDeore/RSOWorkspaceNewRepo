//
//  DeskListingItem.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 17/04/24.
//

import Foundation
struct DeskListingResponse: Codable {
    let status: Bool
    let data: [DeskListingItem]
}
struct DeskListingItem: Codable {
    let id: Int
    let name: String
    let capacity: Int
    let description: String
    let image: String
    let price: String
    let type: String
    let amenityDetails: [ListingAmenityDetail]

    enum CodingKeys: String, CodingKey {
        case id, name, capacity, description, image, price, type
        case amenityDetails = "amenity_details"
    }
}

struct ListingAmenityDetail: Codable {
    let amenityName: String

    enum CodingKeys: String, CodingKey {
        case amenityName = "amenity_name"
    }
}
