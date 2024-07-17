//
//  DeskEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/02/24.
//

import Foundation

enum DeskEndPoint {
    case meetingRooms // Module - GET
    case marketPlaces // GET
}


extension DeskEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .meetingRooms:
            return "meeting-rooms"
        case .marketPlaces:
            return "market-place"
        }
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var method: HTTPMethods {
        switch self {
        case .meetingRooms:
            return .get
        case .marketPlaces:
            return .get
        }
    }
    
    var body: Encodable? {
        switch self {
        case .meetingRooms:
            return nil
        case .marketPlaces:
            return nil
        }
    }
    
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
