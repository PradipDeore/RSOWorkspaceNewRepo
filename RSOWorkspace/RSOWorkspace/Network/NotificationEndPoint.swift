//
//  NotificationEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 17/07/24.
//

import Foundation

enum NotificationEndPoint {
    case notifications // Module - GET
    case feedback(requestModel: FeedbackRequestModel)
}
extension NotificationEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .notifications:
            return "notification"
        case .feedback:
            return "feedback-store"
        }
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    var method: HTTPMethods {
        switch self {
        case .notifications:
            return .get
        case .feedback:
            return .post
        }
    }
    var body: Encodable? {
        switch self {
        case .notifications:
            return nil
        case .feedback(let requestModel):
            return requestModel
        }
    }
        var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
