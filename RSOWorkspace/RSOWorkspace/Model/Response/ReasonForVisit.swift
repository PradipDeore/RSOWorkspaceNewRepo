//
//  ReasonForVisit.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 04/04/24.
//

import Foundation

struct ReasonForVisit: Codable {
    let status: Bool
    let data: [Reason]
}

struct Reason: Codable {
    let id: Int
    let reason: String
}
