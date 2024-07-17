//
//  MyVisitorResponse.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 10/04/24.
//

import Foundation

// Define Visitor model structure
struct MyVisitor: Codable {
    let firstName: String?
    let lastName: String?
    let type: String?
    let locationName: String? // Adjust type if needed
    let companyName: String? // Adjust type if needed
    let visitorManagementId: Int?
    let arrivalDate: String?
    let startTime: String?
    let endTime: String?
    let status: String?
    let reason: String?
    let reasonId: Int?
    let visitorDetails: String?//[VisitorDetail]?
    
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

// Define VisitorDetail model structure
struct VisitorDetail: Codable {
    let visitorName: String
    let visitorEmail: String
    let visitorPhone: String
    
    private enum CodingKeys: String, CodingKey {
        case visitorName = "visitor_name"
        case visitorEmail = "visitor_email"
        case visitorPhone = "visitor_phone"
    }
}

// Define API Response structure
struct MyVisitorAPIResponse: Codable {
    let status: Bool
    let data: [MyVisitor]
}
