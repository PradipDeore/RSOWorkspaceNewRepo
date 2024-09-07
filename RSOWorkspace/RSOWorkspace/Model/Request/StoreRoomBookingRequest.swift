//
//  StoreRoomBookingRequest.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/04/24.
//

import Foundation
//struct StoreRoomBookingRequest: Codable {
//    var amenities: [String] = []
//    var configurations_id: Int = 0
//    let date: String
//    var guestList: [String] = []
//    let location: StoreRoomLocation
//    var memberList: [String] = []
//    let roomId: Int
//    let time: String
//}
//
//struct StoreRoomLocation: Codable {
//    let id: String
//    let name: String
//}

struct StoreRoomBookingRequest:Codable {
    let amenities: [StoreRoomBookingAmenity]?
    let configurationsID: Int?
    let date: String?
    let guestList: [GuestList]?
    let location: StoreRoomBookingLocation?
    let memberList: [TeamList]?
    let roomId: Int?
    let time: String?
    let start_time:String?
    let end_time:String?
}

// MARK: - Amenity
struct StoreRoomBookingAmenity :Codable{
    let amenityPricing, description: String?
    let id, interval: Int?
    let name: String?
    let qty, roomID, totalPrice: Int?
}

// MARK: - GuestList
struct GuestList :Codable{
    let emailId: String?
}
// MARK: - TeamList
struct TeamList :Codable{
    let id: Int?
    let name : String?
}

// MARK: - StoreRoomBookingLocation
struct StoreRoomBookingLocation :Codable{
    let id, name: String?
}

// sample model for api request
//{
//  "amenities": [
//    {
//      "description": "Filler text is text that shares some characteristics of a real written text, but is random or otherwise generated. It may be used to display a sample of fonts, generate text for testing, or to spoof an e-mail spam filter.",
//      "id": 16,
//      "interval": 0,
//      "name": "Amenity 3",
//      "qty": 0,
//      "total_price": 0.0
//    },
//    {
//      "description": "Filler text is text that shares some characteristics of a real written text, but is random or otherwise generated. It may be used to display a sample of fonts, generate text for testing, or to spoof an e-mail spam filter.",
//      "id": 17,
//      "interval": 0,
//      "name": "Amenity 2",
//      "qty": 0,
//      "total_price": 0.0
//    }
//  ],
//  "configurations_id": 0,
//  "date": "2024-09-06",
//  "end_time": "18:00",
//  "guestList": [],
//  "location": {
//    "id": "2",
//    "name": "Etihad Tower"
//  },
//  "memberList": [],
//  "roomId": 7,
//  "start_time": "09:00",
//  "time": "09:00 - 18:00"
//}
