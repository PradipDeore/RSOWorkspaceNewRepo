//
//  LocationGalleryResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 31/07/24.
//

import Foundation

struct LocationGalleryResponseModel: Codable {
    let status: Bool?
    let data: [Gallery]?
}

struct Gallery: Codable {
    let id, locationID: Int?
    let img: String?
    let imgOrder, isDeleted, isActive: Int?
    let createdAt, updatedAt, name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case locationID = "location_id"
        case img
        case imgOrder = "img_order"
        case isDeleted = "is_deleted"
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case name
    }
}
