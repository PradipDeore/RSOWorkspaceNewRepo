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
extension EndPointType{
    
    // developemnt server
//    var baseURL: String {
//        return "https://finance.ardemos.co.in/rso/api/"
//    }
    
    //producton or live server
    var baseURL: String {
        return "https://rso.teamalo.com/api/"
    }
    
//https://rso.teamalo.com
//Or
//https://rso.teamalo.com/api
}
