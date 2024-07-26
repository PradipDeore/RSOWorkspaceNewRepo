//
//  LongTermOfficeBookingRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 26/07/24.
//

import Foundation

struct LongTermOfficeBookingRequestModel: Codable {
    let name: String
    let email: String
    let phone: String
    let interestedIn: Int
    let noOfSeats: Int
    let provideDetails: String
}
