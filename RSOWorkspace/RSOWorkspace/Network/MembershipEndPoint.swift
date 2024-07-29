//
//  MembershipEndPoint.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 27/07/24.
//

import Foundation

enum MembershipEndPoint {
  case getPlans
  case recurringPay(requestModel: SelectedMembershipData)
  case recurringCallback(requestModel: RecurringCallbackRequestModel)
}
extension MembershipEndPoint: EndPointType {
  
  var path: String {
    switch self {
    case .getPlans:
      return "packages"
    case .recurringPay:
      return "recurring-pay"
    case .recurringCallback:
      return "recurring-callback"
    }
  }
  var url: URL? {
    return URL(string: "\(baseURL)\(path)")
  }
  var method: HTTPMethods {
    switch self {
    case .getPlans:
      return .get
    case .recurringPay:
      return .post
    case .recurringCallback:
      return .post
    }
  }
  var body: Encodable? {
    switch self {
    case .getPlans:
      return nil
    case .recurringPay(let requestModel):
      return requestModel
    case .recurringCallback(let requestModel):
      return requestModel
    }
  }
  var headers: [String : String]? {
    APIManager.commonHeaders
  }
}

