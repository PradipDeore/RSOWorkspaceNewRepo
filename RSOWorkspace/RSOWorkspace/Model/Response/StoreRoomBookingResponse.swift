//
//  StoreRoomBookingResponse.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/04/24.
//

import Foundation
// MARK: - StoreRoomBookingResponse
struct StoreRoomBookingResponse: Codable {
    let status: StatusType?
    let time, totalHrs, vatPercent: String?
    let roomDetails: RoomDetails?
    let amenities: [String]?
    let bookingID: Int?
    let orderDetails: RoomBookingOrderDetails?
    let message :String?

    enum CodingKeys: String, CodingKey {
        case status, time, totalHrs
        case vatPercent = "vat_percent"
        case roomDetails = "room_details"
        case amenities
        case bookingID = "booking_id"
        case orderDetails = "order_details"
        case message
    }
}

// MARK: - RoomBookingOrderDetails
struct RoomBookingOrderDetails: Codable {
    let mainprice: Mainprice?
        let weekday: Weekday?
        let weekend: Weekend?
        let surcharge: Surcharge?
        let daytype: String?
        let total: [Total]?
}

// MARK: - Total
struct Total: Codable {
    let name: String?
    let price: String?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case price
    }
}

// MARK: - Mainprice
struct Mainprice: Codable {
    let perHour: String?
    let totalHours, regularHours, surchargeHours: Int?
    let subtotal: String?
    

    enum CodingKeys: String, CodingKey {
        case perHour = "per_hour"
        case totalHours = "total_hours"
        case regularHours = "regular_hours"
        case surchargeHours = "surcharge_hours"
        case subtotal
    }
}

// MARK: - Surcharge
struct Surcharge: Codable {
    let isSurcharge:String?
    let charges: Price?
    let hours:Int?
    let surchargeAmount: Double?

        enum CodingKeys: String, CodingKey {
            case isSurcharge, charges, hours
            case surchargeAmount = "SurchargeAmount"
        }

    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            isSurcharge = try container.decodeIfPresent(String.self, forKey: .isSurcharge)
            charges = try container.decodeIfPresent(Price.self, forKey: .charges)
            hours = try container.decodeIfPresent(Int.self, forKey: .hours)

            // Handle surchargeAmount which might be Int or Double
            if let surchargeAmountInt = try? container.decode(Int.self, forKey: .surchargeAmount) {
                surchargeAmount = Double(surchargeAmountInt)
            } else if let surchargeAmountDouble = try? container.decode(Double.self, forKey: .surchargeAmount) {
                surchargeAmount = surchargeAmountDouble
            } else {
                surchargeAmount = nil
            }
        }
}
// MARK: - Weekday
struct Weekday: Codable {
    let isDiscount: String?
    let discount: Price?
    let original_amount:String?
    let discount_amount:String?
    let discounted_total:String?
    let hours:Int?
   
}

// MARK: - Weekend
struct Weekend: Codable {
    let isCharges:String?
    let charges: Price?
    let hours: Int?
}

enum Price: Codable {
    case integer(Int)
    case string(String)

    // Computed property to return a formatted price as String
    var formattedPrice: String {
        switch self {
        case .integer(let value):
            // Convert integer to a formatted string with no decimal places
            return String(format: "%.0f", Double(value))
        case .string(let value):
            // Try to convert the string to a Double and handle formatting
            if let doubleValue = Double(value) {
                // Check if the double value is a whole number
                if doubleValue.truncatingRemainder(dividingBy: 1) == 0 {
                    return String(format: "%.0f", doubleValue) // No decimals for whole numbers
                } else {
                    return String(format: "%.2f", doubleValue) // Keep two decimal places for fractional numbers
                }
            } else {
                return value // Return the original string if it can't be parsed
            }
        }
    }

    // Decoder to handle Int and String
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Price.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Price"))
    }

    // Encoder to handle Int and String
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}


//enum Price: Codable {
//    case integer(Int)
//    case string(String)
//
//    // Computed property to return a formatted price as String
//    var formattedPrice: String {
//        switch self {
//        case .integer(let value):
//            // Convert integer to a formatted string with 2 decimal places
//            return String(format: "%.2f", Double(value))
//        case .string(let value):
//            // Return the string value, ensuring it always has 2 decimal places
//            if let doubleValue = Double(value) {
//                return String(format: "%.2f", doubleValue)
//            } else {
//                return value // In case the string can't be parsed as a Double, just return the original string
//            }
//        }
//    }
//
//    // Decoder to handle Int and String
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let x = try? container.decode(Int.self) {
//            self = .integer(x)
//            return
//        }
//        if let x = try? container.decode(String.self) {
//            self = .string(x)
//            return
//        }
//        throw DecodingError.typeMismatch(Price.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Price"))
//    }
//
//    // Encoder to handle Int and String
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .integer(let x):
//            try container.encode(x)
//        case .string(let x):
//            try container.encode(x)
//        }
//    }
//}



 //MARK: - RoomDetails
struct RoomDetails: Codable {
    let name: String?
    let price: String?
    let interval:String?
    let totalPrice: TotalPriceType?

    enum CodingKeys: String, CodingKey {
        case name, price, interval
        case totalPrice = "total_price"
    }
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


//------------------------------------------------------
////old room booking respone befoe order booking
//struct StoreRoomBookingResponse: Codable {
//    let status: StatusType?
//    let time: String?
//    let totalHrs: String?
//    let vat_percent: String?
//    let room_details: RoomDetails?
//    let amenities: [String]?
//    let booking_id: Int?
//    let message: String?
//
//}
//
//struct RoomDetails: Codable {
//    let name: String?
//    let price: Float?
//    let interval: String?
//    let total_price: TotalPriceType?
//    
//    enum TotalPriceType: Codable {
//        case int(Int)
//        case string(String)
//        
//        init(from decoder: Decoder) throws {
//            let container = try decoder.singleValueContainer()
//            if let intValue = try? container.decode(Int.self) {
//                self = .int(intValue)
//                return
//            }
//            if let stringValue = try? container.decode(String.self) {
//                self = .string(stringValue)
//                return
//            }
//            throw DecodingError.typeMismatch(TotalPriceType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode TotalPriceType"))
//        }
//        
//        func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            switch self {
//            case .int(let value):
//                try container.encode(value)
//            case .string(let value):
//                try container.encode(value)
//            }
//        }
//    }
//}
//
//
//
//
