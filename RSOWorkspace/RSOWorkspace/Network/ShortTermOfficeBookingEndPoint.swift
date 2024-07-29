//
//  ShortTermOfficeBookingEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 26/07/24.
//

import Foundation

enum ShortTermOfficeBookingEndPoint {
    case storeOfficeBooking(requestModel: StoreOfficeBookingRequest)
}
extension ShortTermOfficeBookingEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .storeOfficeBooking(requestModel: let requestModel):
            return "store-officebooking"
        }
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    var method: HTTPMethods {
        switch self {
        case .storeOfficeBooking(requestModel: let requestModel):
             .post
        }
    }
    var body: Encodable? {
        switch self {
        case .storeOfficeBooking(requestModel: let requestModel):
            return requestModel
        }
    }
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}

