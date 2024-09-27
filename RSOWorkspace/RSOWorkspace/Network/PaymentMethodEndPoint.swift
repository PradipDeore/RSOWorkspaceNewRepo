//
//  PaymentMethodEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 31/07/24.
//

import Foundation

//https://finance.ardemos.co.in/rso/api/card-store?number=1234567812345678&expiry=12/25&card_holder_name=dfdfdsfdf&card_type=debit&id=1
//https://finance.ardemos.co.in/rso/api/get-card

enum PaymentMethodEndPoint {
    case storeCardDetails(requestModel: PaymentMethodRequestModel)
    case getCardDetail
    case getAllBookings(requestModel: GetAllBookingsRequestModel)
    case payment(requestModel: CardPaymentRequestModel)
    
}
extension PaymentMethodEndPoint: EndPointType {
    var path: String {
        switch self {
        case .storeCardDetails:
            return "card-store"
        case .getCardDetail:
            return "get-card"
        case .getAllBookings(requestModel: _):
            return "get-all-bookings"
        case .payment(requestModel: let requestModel):
            return "payment"
        }
    }
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    var method: HTTPMethods {
        switch self {
        case .storeCardDetails:
            return .post
        case .getCardDetail:
            return .get
        case .getAllBookings(requestModel: _):
            return .get
        case .payment(requestModel: let requestModel):
            return .post
        }
    }
    var body: Encodable? {
        switch self {
        case .storeCardDetails(let requestModel):
            return requestModel
        case .getCardDetail:
            return nil
        case .getAllBookings(requestModel: let requestModel):
            return requestModel
        case .payment(requestModel: let requestModel):
            return requestModel
        }
    }
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
