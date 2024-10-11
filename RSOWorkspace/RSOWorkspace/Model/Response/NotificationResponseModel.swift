//
//  NotificationResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/10/24.
//

import Foundation


struct NotificationResponseModel: Codable {
    let status: Bool
    let data: [NotificationData]?
    let unseenCount: Int
    let seenCount: Int
    let id: Int

    enum CodingKeys: String, CodingKey {
        case status
        case data
        case unseenCount
        case seenCount
        case id = "Id"
    }
}

// MARK: - NotificationData
struct NotificationData: Codable {
    let id: Int
    let name: String?
    var isSeen: Int?
    let description: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isSeen = "is_seen"
        case description
        case image
    }
}
