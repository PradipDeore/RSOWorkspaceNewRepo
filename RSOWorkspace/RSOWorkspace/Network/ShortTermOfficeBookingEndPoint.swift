//
//  ShortTermOfficeBookingEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 26/07/24.
//

import Foundation

enum ShortTermOfficeBookingEndPoint {
    case officeBooking(requestModel: BookOfficeRequestModel)
}
extension ShortTermOfficeBookingEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .officeBooking:
            return "store-officebooking"
        }
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    var method: HTTPMethods {
        switch self {
        case .officeBooking:
            return .post
            
        }
    }
    var body: Encodable? {
        switch self {
        case .officeBooking(requestModel: let requestModel):
            return requestModel
        }
    }
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}

