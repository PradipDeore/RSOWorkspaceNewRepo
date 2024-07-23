//
//  PaymentResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 22/07/24.
//

import Foundation
import NISdk

struct PaymentResponseModel: Codable {
    let data: OrderResponse
    let success: Bool
    let statusCode: String

    enum CodingKeys: String, CodingKey {
        case data
        case success
        case statusCode = "status_code"
    }
}
