//
//  PaymentRoomBookingEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 13/04/24.
//

import Foundation

enum PaymentRoomBookingEndPoint {
    case getBookingOfRooms(requestModel: PaymentRoomBookingRequest)
    case getStoreRoomBooking(requestModel: StoreRoomBookingRequest)

}
extension PaymentRoomBookingEndPoint: EndPointType {

    var path: String {
        switch self {
        case .getBookingOfRooms:
            return "payment-roombooking"
        case .getStoreRoomBooking:
            return "store-roombooking"
        }
    }
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    var method: HTTPMethods {
        switch self {
        case .getBookingOfRooms:
            return .post
        case .getStoreRoomBooking:
            return .post
        }
    }
    var body: Encodable? {
        switch self {
        case .getBookingOfRooms(let requestModel):
            return requestModel
        case .getStoreRoomBooking(let requestModel):
            return requestModel
        }
    }
    var headers: [String : String]? {
        //APIManager.commonHeaders
        var commonHeaders = APIManager.commonHeaders
        return commonHeaders
    }
}
