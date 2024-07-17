//
//  ScheduleVisitorsRequest.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 08/04/24.
//

import Foundation

struct ScheduleVisitorsRequest: Codable {
    var reasonOfVisit: String?
    var arrivalDate: String?
    var startTime: String?
    var endTime: String?
    var visitorDetails: [VisitorDetails]?
    
    enum CodingKeys: String, CodingKey {
        case reasonOfVisit = "reason_of_visit"
        case arrivalDate = "arrival_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case visitorDetails = "vistor_details"
    }
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
