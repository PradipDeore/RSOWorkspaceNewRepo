//
//  SocialLoginEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 31/07/24.
//

import Foundation

//https://finance.ardemos.co.in/rso/api/social-login?auth_type=google&auth_id=1234567890

enum SocialLoginEndPoint {
    case socialLogin(requestModel: SocailLoginRequestModel)
}

extension SocialLoginEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .socialLogin(let requestModel):
           // return "social-login?auth_type=\(requestModel.auth_type)&\(requestModel.auth_id)"
            return "social-login?auth_type = \(requestModel.auth_type)&auth_id = \(requestModel.auth_id)&name = \(requestModel.name) &email = \(requestModel.email)"
        }
    }
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    var method: HTTPMethods {
        switch self {
        case .socialLogin:
            return .post
        }
    }
    var body: Encodable? {
        switch self {
        case .socialLogin(let requestModel):
            return requestModel
      
        }
    }
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
