//
//  StoreDeskBookingRequest.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/07/24.
//

import Foundation

struct StoreDeskBookingRequest: Codable {
    var start_time:String?
    var end_time:String?
    var date =  Date.formatSelectedDate(format: .yyyyMMdd, date: nil)
    var is_fullday: String?
    var desktype: Int?
    var desk_id: [Int] = []
    var teammembers: [Int] = [] as! [Int]
}
