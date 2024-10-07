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
    case notificationStatus(notificationId:Int)
}
extension NotificationEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .notifications:
            return "notification"
        case .feedback:
            return "feedback-store"
        case .notificationStatus(let notificationId ):
            return "notification-status/\(notificationId)"
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
        case .notificationStatus:
            return .get
        }
    }
    var body: Encodable? {
        switch self {
        case .notifications:
            return nil
        case .feedback(let requestModel):
            return requestModel
        case .notificationStatus:
            return nil
        }
    }
        var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
