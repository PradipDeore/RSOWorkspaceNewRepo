//
//  GetAllBookingsRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/08/24.
//

import Foundation

struct GetAllBookingsRequestModel: Codable {
    let month: Int
    let year: Int
    
    init(month: Int = Date.getCurrentMonth(), year: Int = Date.getCurrentYear()) {
        self.month = month
        self.year = year
    }
}
