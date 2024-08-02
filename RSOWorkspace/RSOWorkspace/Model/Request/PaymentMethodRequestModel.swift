//
//  PaymentMethodRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 31/07/24.
//

import Foundation

struct PaymentMethodRequestModel: Codable {
    let number: Int
    let expiry:String
    let card_holder_name:String
    let card_type:String
}
