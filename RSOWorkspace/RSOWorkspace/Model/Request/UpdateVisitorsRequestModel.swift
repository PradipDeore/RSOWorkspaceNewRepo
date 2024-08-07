//
//  UpdateVisitorsRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/08/24.
//

import Foundation

struct UpdateVisitorsRequestModel: Codable {
    let id: Int
    let visitor_name:String
    let visitor_phone:String
    let visitor_email:String
}
