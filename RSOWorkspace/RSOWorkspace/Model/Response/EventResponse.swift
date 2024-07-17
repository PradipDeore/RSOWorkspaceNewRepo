//
//  EventResponse.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 25/03/24.
//

import Foundation

struct EventResponse: Codable {
    let status: Bool
    let data: [EventsData]
}

struct EventsData: Codable {
    let id: Int
    let name: String?
    let organizedBy: String?
    let description: String?
    let onetimeDate: String?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, image
        case organizedBy = "organized_by"
        case onetimeDate = "onetime_date"
    }
}
