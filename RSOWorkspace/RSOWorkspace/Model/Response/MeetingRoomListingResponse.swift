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
struct MeetingRoomListing : Codable {
    let id: Int
    let name: String
    let capacity: Int?
    let description: String?
    let image: String?
    let price: String?
    let type: String?
    let amenityDetails: String?//RoomAmenities?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, capacity, description, image, price, type
        case amenityDetails = "amenity_details"
    }
}

struct RoomAmenities: Codable {
    let roomAmenityName: String
    
    private enum CodingKeys: String, CodingKey {
        case roomAmenityName = "room_amenity_name"
    }
}
//struct MeetingRoomDetailsResponseData: Codable {
//    let status: Bool
//    let data: MeetingRoomListing
//}
