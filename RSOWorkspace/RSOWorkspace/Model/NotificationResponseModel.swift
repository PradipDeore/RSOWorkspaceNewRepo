//
//  NotificationResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 17/07/24.
//

import Foundation



struct NotificationResponseModel: Codable {
    let status: Bool?
    let data: [Notifications]?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case status, data
        case id
    }
}

// MARK: - Notifications
struct Notifications: Codable {
    let name, description, image: String?
    // This property will be managed locally in the view controller, not through the API response
       var isRead: Bool = false
    
    enum CodingKeys: String, CodingKey {
            case name, description, image
        }
}
