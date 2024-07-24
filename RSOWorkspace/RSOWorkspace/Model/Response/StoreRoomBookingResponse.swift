//
//  StoreRoomBookingResponse.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/04/24.
//

import Foundation

struct StoreRoomBookingResponse: Codable {
    let status: StatusType?
    let time: String?
    let totalHrs: String?
    let vat_percent: String?
    let room_details: RoomDetails?
    let amenities: [String]?
    let booking_id: Int?
    let message: String?
}

struct RoomDetails: Codable {
    let name: String?
    let price: Int?
    let interval: String?
    let total_price: TotalPriceType?
    
    enum TotalPriceType: Codable {
        case int(Int)
        case string(String)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let intValue = try? container.decode(Int.self) {
                self = .int(intValue)
                return
            }
            if let stringValue = try? container.decode(String.self) {
                self = .string(stringValue)
                return
            }
            throw DecodingError.typeMismatch(TotalPriceType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode TotalPriceType"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .int(let value):
                try container.encode(value)
            case .string(let value):
                try container.encode(value)
            }
        }
    }
}
