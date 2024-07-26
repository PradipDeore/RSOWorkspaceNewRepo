//
//  NotificationEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 17/07/24.
//

import Foundation

enum NotificationEndPoint {
    case notifications // Module - GET
}
extension NotificationEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .notifications:
            return "notification"
        }
    }
    
    var baseURL: String {
        return "https://finance.ardemos.co.in/rso/api/"
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    var method: HTTPMethods {
        switch self {
        case .notifications:
            return .get
        }
    }
    var body: Encodable? {
        switch self {
        case .notifications:
            return nil
        }
    }
        var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
