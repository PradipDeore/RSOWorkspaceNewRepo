//
//  FAQEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/04/24.
//

import Foundation

enum FAQEndPoint {
    case faqs // Module - GET
}
extension FAQEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .faqs:
            return "faqs"
        }
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethods {
        switch self {
        case .faqs:
            return .get
        }
    }
   
    var body: Encodable? {
        switch self {
        case .faqs:
            return nil
        }
    }
    
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
