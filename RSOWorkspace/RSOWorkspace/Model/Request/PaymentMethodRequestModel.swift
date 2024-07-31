//
//  PaymentMethodRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 31/07/24.
//

import Foundation

struct PaymentMethodRequestModel: Codable {
    let card_number: String
    let card_expiry:String
}
