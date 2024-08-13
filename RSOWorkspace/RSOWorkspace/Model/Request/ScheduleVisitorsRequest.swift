//
//  ScheduleVisitorsRequest.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 08/04/24.
//

import Foundation

struct ScheduleVisitorsRequest: Codable {
    var reason_of_visit: Int?
    var arrival_date: String = Date.formatSelectedDate(format: .yyyyMMdd, date: nil)
    var start_time: String =  Date.formatSelectedDate(format: .HHmm, date: nil)
    var end_time: String =  Date.formatSelectedDate(format: .HHmm, date: nil)
    var vistor_details: [MyVisitorDetail]?
}

struct VisitorDetails: Codable {
    var visitorName: String
    var visitorEmail: String
    var visitorPhone: String
    
    enum CodingKeys: String, CodingKey {
        case visitorName = "visitor_name"
        case visitorEmail = "visitor_email"
        case visitorPhone = "visitor_phone"
    }
}
