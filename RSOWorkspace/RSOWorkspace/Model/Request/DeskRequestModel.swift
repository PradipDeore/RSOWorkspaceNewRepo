//
//  DeskRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/04/24.
//

import Foundation
struct DeskRequestModel: Codable {
    var locationid: Int = 0
    var date: String = Date.formatSelectedDate(format: .yyyyMMdd, date: nil)
    var startTime: String = Date.formatSelectedDate(format: .HHmm, date: nil)
    var endTime: String = Date.formatSelectedDate(format: .HHmm, date: nil)
    var isFullDay :String = "No"
    
    enum CodingKeys: String, CodingKey {
        case locationid
        case date
        case startTime = "start_time"
        case endTime = "end_time"
        case isFullDay = "is_fullday"
      
    }
}



