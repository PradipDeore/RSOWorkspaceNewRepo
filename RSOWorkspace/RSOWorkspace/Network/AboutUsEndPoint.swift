//
//  AboutUsEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/04/24.
//

import Foundation

enum AboutUsEndPoint {
    case aboutUs // Module - GET
}
extension AboutUsEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .aboutUs:
            return "about-us"
        }
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethods {
        switch self {
        case .aboutUs:
            return .get
        }
    }
   
    var body: Encodable? {
        switch self {
        case .aboutUs:
            return nil
        }
    }
    
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
