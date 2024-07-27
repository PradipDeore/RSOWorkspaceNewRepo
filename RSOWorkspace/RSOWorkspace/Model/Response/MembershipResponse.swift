//
//  MembershipResponse.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 27/07/24.

import Foundation

// MARK: - Welcome
struct MembershipResponse: Codable {
    let status: Bool?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int?
    let name: String?
    let orderBy: JSONNull?
    let services: [String]?
    let price: [Price]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case orderBy = "order_by"
        case services, price
    }
}

// MARK: - Price
struct Price: Codable {
    let price: String?
    let duration: Duration?
    let length: Int?
}

enum Duration: String, Codable {
    case the10Days = "10 Days"
    case the5Days = "5 Days"
    case unlimited = "Unlimited"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
