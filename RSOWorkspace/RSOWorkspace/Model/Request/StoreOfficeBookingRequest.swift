//
//  StoreOfficeBookingRequest.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 27/07/24.
//

import Foundation

struct StoreOfficeBookingRequest: Codable {
    var start_time:String?
    var end_time:String?
    var date = Date.formatSelectedDate(format: .yyyyMMdd, date: nil)
    var is_fullday:String?
    var office_id:Int?
    var seats:Int = 5
}
