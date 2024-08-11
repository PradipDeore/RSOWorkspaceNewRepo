//
//  UpdateVisitorsRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/08/24.
//

import Foundation

struct UpdateVisitorsRequestModel: Codable {
    var visitor_management_id:Int?
    var reason_of_visit: Int?
    var arrival_date = Date.formatSelectedDate(format: .yyyyMMdd, date: nil)
    var start_time = Date.formatSelectedDate(format: .HHmm, date: nil)
    var end_time = Date.formatSelectedDate(format: .HHmm, date: nil)
    var vistor_detail: [MyVisitorDetail]?
}

struct MyVisitorDetail: Codable {
    var visitor_name, visitor_email, visitor_phone: String?
}
