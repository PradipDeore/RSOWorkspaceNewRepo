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
// MARK: - GuestList
struct TeamList :Codable{
    let id: Int?
    let name : String = "john"
}

// MARK: - StoreRoomBookingLocation
struct StoreRoomBookingLocation :Codable{
    let id, name: String?
}
