//
//  PaymentRoomBookingResponse.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 13/04/24.
//

import Foundation
enum Status: Codable {
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
    throw DecodingError.typeMismatch(Status.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Bool or String"))
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .bool(let boolValue):
      try container.encode(boolValue)
    case .string(let stringValue):
      try container.encode(stringValue)
    }
  }
  var isError: Bool {
    switch self {
    case .string(let stringValue):
      return stringValue.lowercased() == "error"
    default:
      return false
    }
  }
}


struct PaymentRoomBookingResponse: Codable {
    let status: Status
    let message: String
}

struct PaymentDeskBookingResponse: Codable {
    let status: Status
    let msg: String
}

