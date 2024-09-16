//
//  MyBookingResponse.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 04/04/24.
//

import Foundation

struct MyBookingResponse: Codable {
    let status: Bool
    let currentPage:Int?
    var bookMeetings: BookingData? // Dictionary or array of meeting bookings
    var bookDesks: BookingData?
    var mergedBookings: BookingData?

    enum CodingKeys: String, CodingKey {
        case status
        case currentPage = "current_page"
        case bookMeetings = "BookMeetings"
        case bookDesks = "BookDesks"
        case mergedBookings = "mergedBookings"
    }

    // Define an enum to handle different types of booking data
    enum BookingData: Codable {
        case dictionary([String: [MeetingBooking]])
        case array([[MeetingBooking]])

        // Implement Codable methods
        init(from decoder: Decoder) throws {
            if let dictionary = try? decoder.singleValueContainer().decode([String: [MeetingBooking]].self) {
                self = .dictionary(dictionary)
            } else if let array = try? decoder.singleValueContainer().decode([[MeetingBooking]].self) {
                self = .array(array)
            } else {
                throw DecodingError.typeMismatch(BookingData.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected dictionary or array"))
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .dictionary(let dictionary):
                try container.encode(dictionary)
            case .array(let array):
                try container.encode(array)
            }
        }
    }
}


struct MeetingBooking: Codable {
    let id: Int
    let memberId: Int
    let companyId: Int?
    let roomId: Int?
    let configurationsId: Int?
    let intervalId: Int?
    let date: String?
    let startTime: String?
    let endTime: String?
    let totalHours: Int?
    let totalMembers: Int?
    let totalGuest: Int?
    let roomPrice: String?
    let vatAmount: String?
    let totalPrice: String?
    let status: String?
    let additionalRequirements: String?
    let requirementDetails: String?
    let createdAt: String?
    let updatedAt: String?
    let roomName: String?
    let listType: String?
    
    //for desk response parameters
    let deskTypeId: Int?
    let deskNo:String?
    let floorMapId: String?

    enum CodingKeys: String, CodingKey {
        case id
        case memberId = "member_id"
        case companyId = "company_id"
        case roomId = "room_id"
        case configurationsId = "configurations_id"
        case intervalId = "interval_id"
        case date
        case startTime = "start_time"
        case endTime = "end_time"
        case totalHours = "total_hrs"
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
        case listType = "list_type"
        
        case deskTypeId = "desk_type_id"
        case deskNo = "desk_no"
        case floorMapId = "floor_map_id"
    }
}

struct DeskBooking: Codable {
    let id: Int
    let memberId: Int
    let companyId: Int?
    let deskTypeId: Int?
    let startTime: String?
    let endTime: String?
    let date: String?
    let intervalId: Int?
    let vatAmount: String?
    let totalPrice: String?
    let totalMembers: Int?
    let totalHours: Int?
    let status: String?
    let createdAt: String?
    let updatedAt: String?
    let deskNo: String?
    let floorMapId: Int?
    let listType: String?
    let floorNumber:Int?

    enum CodingKeys: String, CodingKey {
        case id
        case memberId = "member_id"
        case companyId = "company_id"
        case deskTypeId = "desk_type_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case date
        case intervalId = "interval_id"
        case vatAmount = "vat_amount"
        case totalPrice = "total_price"
        case totalMembers = "total_members"
        case totalHours = "total_hrs"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deskNo = "desk_no"
        case floorNumber = "floor_number"
        case floorMapId = "floor_map_id"
        case listType = "list_type"
    }
}
