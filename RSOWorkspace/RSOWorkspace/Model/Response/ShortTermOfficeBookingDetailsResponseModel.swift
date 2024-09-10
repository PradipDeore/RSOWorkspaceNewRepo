//
//  ShortTermOfficeBookingDetailsResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 10/09/24.
//

import Foundation

// MARK: - ShortTermOfficeBookingDetailsResponseModel
struct ShortTermOfficeBookingDetailsResponseModel: Codable {
    let status: Bool?
    let data: OfficeDetailsData?
    let amenity: [OfficeDetailsAmenity]?
    let members: [OfficeDetailsMember]?

    enum CodingKeys: String, CodingKey {
        case status, data, amenity
        case members = "Members"
    }
}

// MARK: - OfficeDetailsAmenity
struct OfficeDetailsAmenity: Codable {
    let id: Int?
    let name, description, amenityPricing, priceType: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case amenityPricing = "amenity_pricing"
        case priceType = "price_type"
    }
}

// MARK: - OfficeDetailsData
struct OfficeDetailsData: Codable {
    let id, roomName: String?
    let capacity: Int?
    let description, locationName, roomImage, roomPrice: String?

    enum CodingKeys: String, CodingKey {
        case id
        case roomName = "room_name"
        case capacity, description
        case locationName = "location_name"
        case roomImage = "room_image"
        case roomPrice = "room_price"
    }
}

// MARK: - OfficeDetailsMember
struct OfficeDetailsMember: Codable {
    let id: Int?
    let firstName, lastName, email, photo: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, photo
    }
}
