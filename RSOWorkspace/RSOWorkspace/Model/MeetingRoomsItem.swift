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
    let capacity: Int
    let description: String
    let roomImage: String
    let roomPrice: String
    let locationName: String
    let roomAmenityDetails: String
    
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
