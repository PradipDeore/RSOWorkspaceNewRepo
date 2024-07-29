//
//  ExploreButtonEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 29/07/24.
//

import Foundation
//https://finance.ardemos.co.in/rso/api/common-login?email=bharati.d@aquilmedia.in

enum ExploreButtonEndPoint {
    case exploreLogin(requestModel: exploreRequest)
}
extension ExploreButtonEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .exploreLogin(let requestModel):
            return "common-login?email=\(requestModel.email)"
        }
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethods {
        switch self {
        case .exploreLogin:
            return .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case .exploreLogin(let requestModel):
            return requestModel
      
        }
    }
    
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
