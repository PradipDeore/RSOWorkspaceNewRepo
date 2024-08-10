//
//  UpdateVisitorsRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/08/24.
//

import Foundation

struct UpdateVisitorsRequestModel: Codable {
    let visitor_management_id, reason_of_visit: Int?
    let arrival_date, start_time, end_time: String?
    let vistor_detail: [MyVisitorDetail]?
}

struct MyVisitorDetail: Codable {
    let visitor_name, visitor_email, visitor_phone: String?
}
