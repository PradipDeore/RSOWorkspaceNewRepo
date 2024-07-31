//
//  PaymentMethodEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 31/07/24.
//

import Foundation

//https://finance.ardemos.co.in/rso/api/card-store?number=1234567812345678&expiry=12/25&card_holder_name=dfdfdsfdf&card_type=debit&id=1

enum PaymentMethodEndPoint {
    case getCardDetails(requestModel: PaymentMethodRequestModel)
}
extension PaymentMethodEndPoint: EndPointType {
    var path: String {
        switch self {
        case .getCardDetails(let requestModel):
            return "card-store?auth_type=\(requestModel.number)&\(requestModel.expiry)&\(requestModel.card_holder_name)&\(requestModel.card_type)&\(requestModel.id)"
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
