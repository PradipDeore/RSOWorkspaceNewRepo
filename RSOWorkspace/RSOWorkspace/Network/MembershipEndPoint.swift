//
//  MembershipEndPoint.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 27/07/24.
//

import Foundation

enum MembershipEndPoint {
  case getPlans
}
extension MembershipEndPoint: EndPointType {
  
  var path: String {
    switch self {
    case .getPlans:
      return "packages"
    }
  }
  var url: URL? {
    return URL(string: "\(baseURL)\(path)")
  }
  var method: HTTPMethods {
    switch self {
    case .getPlans:
      return .get
      
    }
  }
  var body: Encodable? {
    switch self {
    case .getPlans:
      return nil
    }
  }
  var headers: [String : String]? {
    APIManager.commonHeaders
  }
}

