//
//  EndPointType.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/02/24.
//

import Foundation

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
}

protocol EndPointType {
    var path: String { get }
    var baseURL: String { get }
    var url: URL? { get }
    var method: HTTPMethods { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
}
// Extend the EndPointType to use the Configuration's baseURL
extension EndPointType {
    var baseURL: String {
        return Configuration.shared.baseURL
    }
}
