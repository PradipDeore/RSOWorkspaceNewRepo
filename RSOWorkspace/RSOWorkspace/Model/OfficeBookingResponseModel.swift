//
//  OfficeBookingResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 17/07/24.
//

import Foundation

// MARK: - Welcome
struct OfficeBookingResponseModel: Codable {
    let status: Bool
    let data: BookOffice
    let vatpercent: String?
}
// MARK: - DataClass
struct BookOffice: Codable {
    let id, memberID: Int
    let companyID: Int?
    let officeID: Int
    let date, startTime, endTime: String
    let intervalID: Int?
    let totalHrs, seats: Int?
    let price: String?
    let vatAmount, totalPrice: Int?
    let status, createdAt, updatedAt, name: String?

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
    }
}
