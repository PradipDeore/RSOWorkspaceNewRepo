//
//  LocationEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 29/02/24.
//

import Foundation

enum LocationEndPoint {
    case locations // Module - GET
}
extension LocationEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .locations:
            return "all-locations"
           
        }
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethods {
        switch self {
        case .locations:
            return .get
            
        }
    }
    
    var body: Encodable? {
        switch self {
        case .locations:
            return nil
      
        }
    }
    
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
