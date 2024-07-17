//
//  MarketPlaceItem.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/02/24.
//

import Foundation

struct MarketPlaceItem: Codable {
    let headerType: String
    let headerImg: String
    let headerText: String?
    let headline: String
    let headline2: String
    let subtext: String
    let location: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case headerType = "header_type"
        case headerImg = "header_img"
        case headerText = "header_text"
        case headline, headline2, subtext, location, image
    }
}
struct MarketPlaceResponse: Codable {
        let status: Bool
        let data: [MarketPlaceItem]
    }

