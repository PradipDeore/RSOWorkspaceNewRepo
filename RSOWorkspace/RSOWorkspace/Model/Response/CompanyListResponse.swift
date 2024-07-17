//
//  CompanyListResponse.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 26/03/24.
//

import Foundation

struct Company: Codable {
    let id: Int
    let name: String
    let phone: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case phone
        case description
    }
   
}

struct CompanyListResponse: Codable {
    let status: Bool
    let data: [Company]
}
