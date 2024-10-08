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
    //let total_price: Double
    let total:Double
    let vatamount: Double
}

struct PaymentDeskBookingRequest: Codable {
    let bookingid: Int
    let total_amount: Double
    let vat_amount: Double
}
