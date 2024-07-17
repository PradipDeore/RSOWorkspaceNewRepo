//
//  BookingDetailsRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 12/03/24.
//

import Foundation
struct BookingDetailsRequestModel: Codable {
    var date: String
    var startTime: String
    var endTime: String
    var isFullDay: Bool
    
    enum CodingKeys: String, CodingKey {
        case date
        case startTime = "start_time"
        case endTime = "end_time"
        case isFullDay = "is_fullday"
    }
    
    init() {
        self.startTime = ""
        self.endTime = ""
        self.date = ""
        self.isFullDay = false
    }
}
