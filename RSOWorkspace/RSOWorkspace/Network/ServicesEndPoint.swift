//
//  ServicesEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 19/03/24.
//

import Foundation

enum ServicesEndPoint {
    case onDemandServices(serviceId:Int?) // Module - GET
    case subServices(requestModel:subServicesRequestModel)
    case reportAnIssue(requestModel: ReportAnIssueRequestModel)
}
extension ServicesEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .onDemandServices(let serviceid):
            return "on-demand-service??service_id=\(serviceid)"
        case .reportAnIssue:
            return "report-issue"
        case .subServices(requestModel: let requestModel):
            return "concierge-service"
        }
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
        case .subServices(requestModel: let requestModel):
            return .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .onDemandServices:
            return nil
        case .reportAnIssue(let requestModel):
            return requestModel
        case .subServices(requestModel: let requestModel):
            return requestModel
        }
    }
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
