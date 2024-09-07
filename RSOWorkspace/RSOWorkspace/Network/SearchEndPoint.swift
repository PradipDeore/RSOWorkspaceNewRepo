//
//  SearchEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/08/24.
//

import Foundation

enum SearchEndPoint {
    case searchItems(searchItemName:String)
}
extension SearchEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .searchItems(let searchItemName):
            return "search?search=\(searchItemName)"
        }
    }
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
        var method: HTTPMethods {
        switch self {
        case .searchItems:
            return .get
        }
    }
    var body: Encodable? {
        switch self {
        case .searchItems:
            return nil
        }
    }
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
