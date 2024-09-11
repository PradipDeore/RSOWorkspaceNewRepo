//
//  StoreofficeBookingResponse.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 27/07/24.
//

import Foundation

// MARK: - StoreofficeBookingResponse
struct StoreofficeBookingResponse: Codable {
    let status: Bool?
    let data: StoreofficeBooking?
    let vatpercent: String?
    let msg:String?
    let orderDetails: OfficeBookingOrderDetails?

    enum CodingKeys: String, CodingKey {
           case status, data, vatpercent,msg
           case orderDetails = "order_details"
       }
}

// MARK: - StoreofficeBooking
struct StoreofficeBooking: Codable {
    let id, memberID: Int?
    let companyID: Int?
    let officeID: Int?
    let date, startTime, endTime: String?
    let intervalID: Int?
    let totalHrs, seats: Int?
    let price: String?
    let vatAmount, totalPrice: String?
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

// MARK: - OfficeBookingOrderDetails
struct OfficeBookingOrderDetails: Codable {
    let mainprice: MainpriceOfficeOrderDetails?
    let weekday: WeekdayOfficeOrderDetails?
    let weekend: WeekendOfficeOrderDetails?
    let surcharge: SurchargeOfficeOrderDetails?
    let daytype: String?
    let total: [TotalOfficeOrderDetails]?
}

// MARK: - MainpriceOfficeOrderDetails
struct MainpriceOfficeOrderDetails: Codable {
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

// MARK: - SurchargeOfficeOrderDetails
struct SurchargeOfficeOrderDetails: Codable {
    let isSurcharge:String?
    let charges: PriceType?
    let hours: Int?
    let surchargeAmount: Double?

    enum CodingKeys: String, CodingKey {
        case isSurcharge, charges, hours
        case surchargeAmount = "SurchargeAmount"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        isSurcharge = try container.decodeIfPresent(String.self, forKey: .isSurcharge)
        charges = try container.decodeIfPresent(PriceType.self, forKey: .charges)
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

// MARK: - TotalOfficeOrderDetails
struct TotalOfficeOrderDetails: Codable {
    let name, price: String?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case price
    }
}

// MARK: - WeekdayOfficeOrderDetails
struct WeekdayOfficeOrderDetails: Codable {
    let isDiscount: String?
    let discount: PriceType?
    let hours: Int?
    let original_amount: String?
    let discount_amount:String?
    let discounted_total:String?
}


// MARK: - WeekendOfficeOrderDetails
struct WeekendOfficeOrderDetails: Codable {
    let isCharges: String?
    let charges: PriceType?
}

enum PriceType: Codable {
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


