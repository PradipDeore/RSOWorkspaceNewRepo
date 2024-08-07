//
//  GetAllBookingsResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/08/24.
//

import Foundation
// MARK: - GetAllBookingsResponseModel
struct GetAllBookingsResponseModel: Codable {
    let status: Bool?
    let data: [GetAllBookings]?
}

// MARK: - GetAllBookings
struct GetAllBookings: Codable {
    let id, memberID, companyID, officeID: Int?
    let date, startTime, endTime: String?
    let intervalID, totalHrs, seats: Int?
    let price, vatAmount: String?
    let totalPrice: String?
    let status: Status?
    let createdAt, updatedAt: String?
    let name: String?
    let roomID: Int?
    let configurationsID: Int?
    let totalMembers, totalGuest: Int?
    let roomPrice, additionalRequirements: String?
    let requirementDetails: String?

    enum CodingKeys: String, CodingKey {
        case id
        case memberID = "member_id"
        case companyID = "company_id"
        case officeID = "office_id"
        case date
        case startTime = "start_time"
        case endTime = "end_time"
        case intervalID = "interval_id"
        case totalHrs = "total_hrs"
        case seats, price
        case vatAmount = "vat_amount"
        case totalPrice = "total_price"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case name
        case roomID = "room_id"
        case configurationsID = "configurations_id"
        case totalMembers = "total_members"
        case totalGuest = "total_guest"
        case roomPrice = "room_price"
        case additionalRequirements = "additional_requirements"
        case requirementDetails = "requirement_details"
    }
}
