//
//  AboutUsResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 11/10/24.
//

import Foundation

struct AboutUsResponseModel: Codable {
    let status: Bool?
    let title: String?
    let data: [AboutRSO]?
}

// MARK: - Datum
struct AboutRSO: Codable {
    let sec5Title, sec5Desc, sec5Img: String?
}
