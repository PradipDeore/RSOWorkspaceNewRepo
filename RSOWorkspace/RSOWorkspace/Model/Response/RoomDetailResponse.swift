//
//  RoomDetails.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 12/03/24.
//
//https://finance.ardemos.co.in/rso/api/room-details/2?date=2024-02-25&start_time=09:00&end_time=12:00&is_fullday=Yes

import Foundation
struct RoomDetailResponse: Codable {
    let status: Bool
    let data: RoomData
    let amenity: [Amenity]
    let members: [TeamMembersList]? // Assuming it's an array of strings or null
    let datetime: Datetime
}

struct RoomData: Codable {
    let id: Int
    let name: String
    let capacity: Int
    let description: String
    let locationName: String
    let image: String
    let price: String
    let configurationsDetails:[ConfigurationDetails]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case capacity
        case description
        case locationName = "location_name"
        case image
        case price
        case configurationsDetails = "configurations_details"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        capacity = try container.decode(Int.self, forKey: .capacity)
        description = try container.decode(String.self, forKey: .description)
        locationName = try container.decode(String.self, forKey: .locationName)
        image = try container.decode(String.self, forKey: .image)
        price = try container.decode(String.self, forKey: .price)
        // Decode configurationsDetails from custom string representation
        let configurationsString = try container.decode(String.self, forKey: .configurationsDetails)
        let jsonData = configurationsString.data(using: .utf8)!
        configurationsDetails = try JSONDecoder().decode([ConfigurationDetails].self, from: jsonData)
        print("configurationsDetails",configurationsDetails)
    }
}

struct ConfigurationDetails: Codable {
    let configurationId: Int?
    let configurationName: String?
    let configurationImage: String?
    enum CodingKeys: String, CodingKey {
        case configurationId = "configuration_id"
        case configurationName = "configuration_name"
        case configurationImage = "configuration_image"
    }
}

struct Amenity: Codable {
    let id: Int
    let name: String?
    let description: String?
    let pricing: String?
    let price: String?
}
struct TeamMembersList: Codable {
    let id: Int
    let first_name: String?
    let last_name: String?
    let photo: String?
}

struct Datetime: Codable {
    let date: String
    let startTime: String
    let endTime: String
    enum CodingKeys: String, CodingKey {
        case date
        case startTime = "start_time"
        case endTime = "end_time"
    }
}
