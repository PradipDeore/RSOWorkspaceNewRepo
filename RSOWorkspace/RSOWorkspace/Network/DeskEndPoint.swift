//
//  DeskEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/02/24.
//

import Foundation
//https://finance.ardemos.co.in/rso/api/meeting-rooms/1?start_time=10&end_time=12&date=2024-08-10

enum DeskEndPoint {
    case meetingRooms(id: Int?, requestModel: MeetingRoomItemRequestModel?) // Module - GET
    case marketPlaces // GET
}


extension DeskEndPoint: EndPointType {
    
    var path: String {
        switch self {
        case .meetingRooms(let id ,_):
            if let locationId = id {
              return "meeting-rooms/\(locationId)"
            } else {
                return "meeting-rooms/1"
            }
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
        case .meetingRooms(_, let requestModel):
            return requestModel
        case .marketPlaces:
            return nil
        }
    }
    
    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
