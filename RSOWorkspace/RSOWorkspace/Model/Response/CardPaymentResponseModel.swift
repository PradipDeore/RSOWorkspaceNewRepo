//
//  CardPaymentResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 26/09/24.
//

import Foundation

// MARK: - CardPaymentResponseModel
struct CardPaymentResponseModel: Codable {
    let status: Bool
    let error: String?
}
