//
//  ServicesEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 19/03/24.
//

import Foundation

enum ServicesEndPoint {
    case onDemandServices // Module - GET
    case subSevices(requestModel:subServicesRequestModel)
    case reportAnIssue(requestModel: ReportAnIssueRequestModel)
}
extension ServicesEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .onDemandServices:
            return "on-demand-service"
        case .reportAnIssue:
            return "report-issue"
        case .subSevices(requestModel: let requestModel):
            return "demand-service"
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
        case .onDemandServices:
            return .get
        case .reportAnIssue:
            return .post
        case .subSevices(requestModel: let requestModel):
            return .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .onDemandServices:
            return nil
        case .reportAnIssue(let requestModel):
            return requestModel
        case .subSevices(requestModel: let requestModel):
            return requestModel
        }
    }
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
