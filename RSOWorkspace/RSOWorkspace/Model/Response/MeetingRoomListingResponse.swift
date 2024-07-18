//
//  MeetingRoomListingResponse.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/03/24.
//

//https://finance.ardemos.co.in/rso/api/meeting-rooms-listing/1?date=2024-02-25&start_time=09:00&end_time=12:00&is_fullday=false

import Foundation

// Model for the main response data
struct MeetingRoomListingResponse: Codable {
  let status: Bool
  let data: [MeetingRoomListing]
}

struct MeetingRoomListing: Codable {
  let id: Int
  let roomName: String?
  let capacity: Int?
  let description: String?
  let roomImage: String?
  let roomPrice: String?
  let locationName: String?
  let roomAmenityDetails: [RoomAmenities]?
  
  private enum CodingKeys: String, CodingKey {
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
    roomName =  try container.decodeIfPresent(String.self, forKey: .roomName)
    capacity = try container.decodeIfPresent(Int.self, forKey: .capacity)
    description = try container.decodeIfPresent(String.self, forKey: .description)
    roomImage = try container.decodeIfPresent(String.self, forKey: .roomImage)
    roomPrice = try container.decodeIfPresent(String.self, forKey: .roomPrice)
    locationName = try container.decodeIfPresent(String.self, forKey: .locationName)
    
    let roomAmenitiesString = try container.decodeIfPresent(String.self, forKey: .roomAmenityDetails)
    if let amenitiesString = roomAmenitiesString, let amenitiesData = amenitiesString.data(using: .utf8) {
      roomAmenityDetails = try JSONDecoder().decode([RoomAmenities].self, from: amenitiesData)
    } else {
      roomAmenityDetails = nil
    }
  }
}

struct RoomAmenities: Codable {
  let roomAmenityName: String
  
  private enum CodingKeys: String, CodingKey {
    case roomAmenityName = "room_amenity_name"
  }
}
