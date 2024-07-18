//
//  DeskListItem.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/02/24.
//

//https://finance.ardemos.co.in/rso/api/meeting-rooms
import Foundation

// Model for individual room data
struct MeetingRoomsItem: Codable {
    let id: Int
    let roomName: String
    let capacity: Int?
    let description: String?
    let roomImage: String?
    let roomPrice: String?
    let locationName: String?
    let roomAmenityDetails: [RoomAmenities]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case roomName = "room_name"
        case capacity
        case description
        case roomImage = "room_image"
        case roomPrice = "room_price"
        case locationName = "location_name"
        case roomAmenityDetails = "room_amenity_details"
    }
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int.self, forKey: .id)
    roomName = try container.decode(String.self, forKey: .roomName)
    capacity = try container.decodeIfPresent(Int.self, forKey: .capacity)
    description = try container.decodeIfPresent(String.self, forKey: .description)
    roomImage = try container.decodeIfPresent(String.self, forKey: .roomImage)
    roomPrice = try container.decodeIfPresent(String.self, forKey: .roomPrice)
    locationName = try container.decodeIfPresent(String.self, forKey: .locationName)
    
    let amenitiesString = try container.decode(String.self, forKey: .roomAmenityDetails)
    if let amenitiesData = amenitiesString.data(using: .utf8) {
      roomAmenityDetails = try JSONDecoder().decode([RoomAmenities].self, from: amenitiesData)
    } else {
      roomAmenityDetails = nil
    }
  }
}

// Model for room amenity details
struct RoomAmenity: Codable {
    let roomAmenityName: String
    
    enum CodingKeys: String, CodingKey {
        case roomAmenityName = "room_amenity_name"
    }
}

// Model for the main response data
struct ResponseData: Codable {
    let status: Bool
    let data: [MeetingRoomsItem]
}
