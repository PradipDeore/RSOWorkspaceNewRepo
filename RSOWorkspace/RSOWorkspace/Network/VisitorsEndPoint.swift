//
//  VisitorsEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 04/04/24.
//

import Foundation

enum VisitorsEndPoint {
    case reasonForVisit // Module - GET
    case scheduleVisitors(requestModel : ScheduleVisitorsRequest)
    case myVisitors

}
extension VisitorsEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .reasonForVisit:
            return "visitor-reasons"
        case .scheduleVisitors:
            return "visitor-schedule"
        case .myVisitors:
            return "my-visitors"
        }
    }
  
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethods {
        switch self {
        case .reasonForVisit:
            return .get
        case .scheduleVisitors:
            return .post
        case .myVisitors:
            return .get
        }
    }
    
    var body: Encodable? {
        switch self {
        case .reasonForVisit:
            return nil
        case .scheduleVisitors(let requestModel):
            return requestModel
        case .myVisitors:
            return nil
        }
    }
    
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
