//
//  MyProfileEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/04/24.
//

import Foundation

enum MyProfileEndPoint {
    case myProfile // Module - GET
    case updateProfile(requestModel: UpdateProfileRequestModel)
}
extension MyProfileEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .myProfile:
            return "my-profile"
        case .updateProfile:
            return "my-profile-update"
        }
    }
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethods {
        switch self {
        case .myProfile:
            return .get
        case .updateProfile:
            return .post
        }
    }
   
    var body: Encodable? {
        switch self {
        case .myProfile:
            return nil
        case .updateProfile(let requestModel):
            return requestModel
        }
    }
    
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
