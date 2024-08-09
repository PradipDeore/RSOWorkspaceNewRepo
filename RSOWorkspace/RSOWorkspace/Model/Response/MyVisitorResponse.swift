//
//  MyVisitorResponse.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 10/04/24.
//

import Foundation

// Model for the individual visitor details
struct VisitorDetail: Codable {
    let visitorName: String?
    let visitorEmail: String?
    let visitorPhone: String?
    
    private enum CodingKeys: String, CodingKey {
        case visitorName = "visitor_name"
        case visitorEmail = "visitor_email"
        case visitorPhone = "visitor_phone"
    }
}


// Model for the main visitor data
struct MyVisitor: Codable {
    let firstName: String?
    let lastName: String?
    let type: String?
    let locationName: String?
    let companyName: String?
    let visitorManagementId: Int?
    let arrivalDate: String?
    let startTime: String?
    let endTime: String?
    let status: String?
    let reason: String?
    let reasonId: Int?
    let visitorDetails: String? // This is a JSON string
    
    // Optional: Decode visitorDetails from JSON string to [VisitorDetail]
    var visitorDetailsArray: [VisitorDetail]? {
        guard let data = visitorDetails?.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode([VisitorDetail].self, from: data)
    }
   
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case type
        case locationName = "location_name"
        case companyName = "company_name"
        case visitorManagementId = "visitor_management_id"
        case arrivalDate = "arrival_date"
        case startTime = "start_time"
        case endTime = "end_time"
        case status
        case reason
        case reasonId = "reason_id"
        case visitorDetails = "visitor_details"
    }
}

// Model for the API response
struct MyVisitorAPIResponse: Codable {
    let status: Bool
    let data: [MyVisitor]
}

