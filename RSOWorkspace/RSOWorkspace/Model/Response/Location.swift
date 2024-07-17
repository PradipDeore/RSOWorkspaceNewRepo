//
//  Location.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 29/02/24.
//

import Foundation

struct Location: Codable {
    let id: Int
    let name: String
}

struct ApiResponse: Codable {
    let status: Bool
    let data: [Location]
}
