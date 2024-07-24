//
//  PaymentRoomBookingEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 13/04/24.
//

import Foundation

enum PaymentRoomBookingEndPoint {
    case paymentRoombooking(requestModel: PaymentRoomBookingRequest)
    case getStoreRoomBooking(requestModel: StoreRoomBookingRequest)
    case payment(requestModel: NiPaymentRequestModel)
    case applyCoupon
    case paymentDeskbooking(requestModel: PaymentDeskBookingRequest)
}
extension PaymentRoomBookingEndPoint: EndPointType {

    var path: String {
        switch self {
        case .paymentRoombooking:
            return "payment-roombooking"
        case .getStoreRoomBooking:
            return "store-roombooking"
        case .payment:
            return "ios-payment"
        case .applyCoupon:
            return "coupon-details"
        case .paymentDeskbooking:
            return "payment-deskbooking"
        }
    }
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    var method: HTTPMethods {
        switch self {
        case .paymentRoombooking:
            return .post
        case .getStoreRoomBooking:
            return .post
        case .payment:
            return .post
        case .applyCoupon:
            return .get
        case .paymentDeskbooking:
            return .post
        }
    }
    var body: Encodable? {
        switch self {
        case .paymentRoombooking(let requestModel):
            return requestModel
        case .getStoreRoomBooking(let requestModel):
            return requestModel
        case .payment(let requestModel):
            return requestModel
        case .applyCoupon:
            return nil
        case .paymentDeskbooking(let requestModel):
            return requestModel
        }
    }
    var headers: [String : String]? {
        //APIManager.commonHeaders
        let commonHeaders = APIManager.commonHeaders
        return commonHeaders
    }
}
