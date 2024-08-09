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
    case myVisitors(date:String)
    case updateVisitors(requestModel : UpdateVisitorsRequestModel)

}
extension VisitorsEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .reasonForVisit:
            return "visitor-reasons"
        case .scheduleVisitors:
            return "visitor-schedule"
        case .myVisitors(let date):
            return "my-visitors?date=\(date)"
        case .updateVisitors:
            return "visitor-details-update"
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
        case .updateVisitors:
            return .post
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
        case .updateVisitors(let requestModel):
            return requestModel
        }
    }
    
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
