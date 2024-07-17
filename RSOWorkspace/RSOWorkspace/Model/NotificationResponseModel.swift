//
//  NotificationResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 17/07/24.
//

import Foundation

struct NotificationResponseModel: Codable {
    let status: Bool
    let data: [Notifications]
}

// MARK: - Datum
struct Notifications: Codable {
    let name, description, image: String?
}
