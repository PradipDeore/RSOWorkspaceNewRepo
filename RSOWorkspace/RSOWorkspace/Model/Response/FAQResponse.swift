//
//  FAQResponse.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/04/24.
//

import Foundation

struct FAQResponse: Codable {
    let status: Bool
    let data: [FaqData]
}

struct FaqData: Codable {
    let id: Int
    let title: String
    let description: String
}
