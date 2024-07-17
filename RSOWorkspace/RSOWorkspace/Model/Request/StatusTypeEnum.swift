//
//  StatusTypeEnum.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 16/04/24.
//

import Foundation
enum StatusType: Codable {
    case bool(Bool)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let boolValue = try? container.decode(Bool.self) {
            self = .bool(boolValue)
            return
        }
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
            return
        }
        throw DecodingError.typeMismatch(StatusType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Failed to decode StatusType"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}
