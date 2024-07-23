//
//  StoreDeskBookingResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/07/24.
//

import Foundation

struct StoreDeskBookingResponseModel: Codable {
    var status: Bool?
    var vatpercent: String?
    var data: StoreDeskBooking?
    var desks: [Desk]?
    var msg: String?
}

struct StoreDeskBooking: Codable {
    let id, memberID: Int
    let companyID: Int?
    let deskTypeID: Int
    let startTime, endTime, date: String
    let intervalID, vatAmount, totalPrice: Float?
    let totalMembers, totalHrs: Int
    let status, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case memberID = "member_id"
        case companyID = "company_id"
        case deskTypeID = "desk_type_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case date
        case intervalID = "interval_id"
        case vatAmount = "vat_amount"
        case totalPrice = "total_price"
        case totalMembers = "total_members"
        case totalHrs = "total_hrs"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Desk
struct Desk: Codable {
    let id: Int
    let price, name: String
}
