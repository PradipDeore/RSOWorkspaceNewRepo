//
//  PaymentRoomBookingRequest.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 13/04/24.
//

import Foundation

struct PaymentRoomBookingRequest: Codable {
    let additional_requirements: [String]
    let booking_id: Int
    let requirement_details: String
    let total_price: Double
    let vatamount: Double
}

struct PaymentDeskBookingRequest: Codable {
    let booking_id: Int
    let total_price: Double
    let vatamount: Double
}
