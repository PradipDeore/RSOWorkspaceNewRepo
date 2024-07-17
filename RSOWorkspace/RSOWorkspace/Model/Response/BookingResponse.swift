//
//  BookingResponse.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 28/02/24.
//

import Foundation
struct BookingResponse: Codable {
    let status: Bool
    let resultData: [Booking]?
    let lastPage: Int?
    let perPage: Int?
    let currentPage: Int?
    let total: Int?
    let msg: String?
    
    
    enum CodingKeys: String, CodingKey {
        case status
        case resultData = "data"
        case lastPage = "last_page"
        case perPage = "per_page"
        case currentPage = "current_page"
        case total
        case msg
    }
}

struct Booking: Codable {
    let id: Int
    let memberId: Int?
    let companyId: Int?
    let roomId: Int?
    let configurationsId: Int?
    let intervalId: Int?
    let date: String?
    let startTime: String?
    let endTime: String?
    let totalHrs: Int?
    let totalMembers: Int?
    let totalGuest: Int?
    let roomPrice: String
    let vatAmount: String
    let totalPrice: String?
    let status: String?
    let additionalRequirements: String?
    let requirementDetails: String?
    let createdAt: String?
    let updatedAt: String?
    let roomName: String?
    let type: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case memberId = "member_id"
        case companyId = "company_id"
        case roomId = "room_id"
        case configurationsId = "configurations_id"
        case intervalId = "interval_id"
        case date
        case startTime = "start_time"
        case endTime = "end_time"
        case totalHrs = "total_hrs"
        case totalMembers = "total_members"
        case totalGuest = "total_guest"
        case roomPrice = "room_price"
        case vatAmount = "vat_amount"
        case totalPrice = "total_price"
        case status
        case additionalRequirements = "additional_requirements"
        case requirementDetails = "requirement_details"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case roomName = "room_name"
        case type
    }
}
