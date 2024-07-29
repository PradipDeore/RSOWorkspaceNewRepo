//
//  ShortTermPaymentOfficeBookingRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 29/07/24.
//

import Foundation

struct ShortTermPaymentOfficeBookingRequestModel: Codable {
    let id: Int
    let total_price: Double
    let vat_amount: Double
}
