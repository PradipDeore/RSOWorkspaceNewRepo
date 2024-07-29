//
//  LongTermOfficeBookingEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 26/07/24.
//

import Foundation

enum LongTermOfficeBookingEndPoint {
    case getOfficeBookingReasons // Module - GET
    case longTermOfficeBooking(requestModel:LongTermOfficeBookingRequestModel)
}
extension LongTermOfficeBookingEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .getOfficeBookingReasons:
            return "long-term-booking-reasons"
        case .longTermOfficeBooking(requestModel: let requestModel):
            return "long-term-office-booking"
        }
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    var method: HTTPMethods {
        switch self {
        case .getOfficeBookingReasons:
            return .get
        case .longTermOfficeBooking(requestModel: _):
            return .post
        }
    }
    var body: Encodable? {
        switch self {
        case .getOfficeBookingReasons:
            return nil
        case .longTermOfficeBooking(requestModel: let requestModel):
            return requestModel
        }
    }
        var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
