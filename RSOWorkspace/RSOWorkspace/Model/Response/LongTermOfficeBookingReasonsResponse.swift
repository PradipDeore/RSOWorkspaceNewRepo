//
//  LongTermOfficeBookingReasonsResponse.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 26/07/24.
//

import Foundation

// MARK: - LongTermOfficeBookingReasonsResponse
struct LongTermOfficeBookingReasonsResponse :Codable{
    let data: [OfficeBookingReasons]?
}

// MARK: - OfficeBookingReasons
struct OfficeBookingReasons:Codable {
    let id: Int?
    let intrest: String?
}
