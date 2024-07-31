//
//  PaymentMethodEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 31/07/24.
//

import Foundation

//https://finance.ardemos.co.in/rso/api/card-store?card_number=1234567812345678&card_expiry=12/25

enum PaymentMethodEndPoint {
    case getCardDetails(requestModel: PaymentMethodRequestModel)
}
extension PaymentMethodEndPoint: EndPointType {
    var path: String {
        switch self {
        case .getCardDetails(let requestModel):
            return "card-store?auth_type=\(requestModel.card_number)&\(requestModel.card_expiry)"
        }
    }
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    var method: HTTPMethods {
        switch self {
        case .getCardDetails:
            return .post
        }
    }
    var body: Encodable? {
        switch self {
        case .getCardDetails(let requestModel):
            return requestModel
        }
    }
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
