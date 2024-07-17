//
//  MemberSearchRequest.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 26/03/24.
//

import Foundation
struct MemberSearchRequest: Codable {
    let membersSearch: String?
    let companyId: Int?
    
    enum CodingKeys: String, CodingKey {
        case membersSearch = "members_search"
        case companyId = "company_id"
    }
}
