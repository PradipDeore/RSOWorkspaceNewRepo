//
//  LogInSignUpEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 22/02/24.
//

import Foundation

enum LogInSignUpEndPoint {
    case logIn(requestModel : LoginRequestModel)
    case forgotPassword(requestModel : ForgotPasswordRequestModel)
    case signUp(requestModel : SignUpRequestModel)
}
extension LogInSignUpEndPoint: EndPointType {

    var path: String {
        switch self {
        case .logIn:
            return "login"
        case .forgotPassword:
            return "forgot-password"
        case .signUp:
            return "register"
        }
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .logIn:
            return .post
        case .forgotPassword:
            return .post
        case .signUp:
            return .post
        }
    }

    var body: Encodable? {
        switch self {
        case .logIn(let requestModel):
            return requestModel
        case .forgotPassword(let requestModel):
            return requestModel
        case .signUp(let requestModel):
            return requestModel
        }
    }

    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
