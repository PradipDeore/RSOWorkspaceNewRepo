//
//  CommuneEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 25/03/24.
//

import Foundation

enum CommuneEndPoint {
    case events // Module - GET
    case memberList(requestModel: MemberSearchRequest)
    case companyList
    case rsvp(requestModel : rsvpRequestModel)
}
extension CommuneEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .events:
            return "events"
        case .memberList:
            return "members-list"
        case .companyList:
            return "companies-list"
        case .rsvp:
            return "rsvp"
        }
    }
    
    var baseURL: String {
        return "https://finance.ardemos.co.in/rso/api/"
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethods {
        switch self {
        case .events:
            return .get
        case .memberList:
            return .get
        case .companyList:
            return .get
        case .rsvp:
            return .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .events:
            return nil
        case .memberList(let requestModel):
            return requestModel
        case .companyList:
            return nil
        case .rsvp(let requestModel):
            return requestModel
        }
    }
    
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
