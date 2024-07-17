//
//  StoreRoomBookingRequest.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/04/24.
//

import Foundation
struct StoreRoomBookingRequest: Codable {
    var amenities: [String] = []
    var configurations_id: Int = 0
    let date: String
    var guestList: [String] = []
    let location: StoreRoomLocation
    var memberList: [String] = []
    let roomId: Int
    let time: String
}

struct StoreRoomLocation: Codable {
    let id: String
    let name: String
}
