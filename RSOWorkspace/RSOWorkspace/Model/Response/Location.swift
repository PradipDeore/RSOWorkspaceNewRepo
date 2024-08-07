//
//  Location.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 29/02/24.
//

import Foundation

// MARK: - Location
struct LocationResponse: Codable {
    let status: Bool?
    let data: [LocationDetails]?
}

// MARK: - LocationDetails
struct LocationDetails: Codable {
    let id: Int?
    let name, geoLocation, latitude, longitude: String?
    let address1, address2: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case geoLocation = "geo_location"
        case latitude, longitude, address1, address2
    }
}
