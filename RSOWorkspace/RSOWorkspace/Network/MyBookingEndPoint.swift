//
//  MyBookingEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 28/02/24.
//

import Foundation
enum MyBookingEndPoint {
    case myBookingListing
    case getAvailableMeetingRoomListing(id: Int, requestModel: BookMeetingRoomRequestModel)
    case getDetailsOfMeetingRooms(id: Int, requestModel: BookMeetingRoomRequestModel)
}
extension MyBookingEndPoint: EndPointType {

    var path: String {
        switch self {
        case .myBookingListing:
            return "my-bookings"
        case .getAvailableMeetingRoomListing(let id ,_):
            return "meeting-rooms-listing/\(id)"
        case .getDetailsOfMeetingRooms(let id ,_):
            return "room-details/\(id)"
        }
    }
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .myBookingListing:
            return .get
        case .getAvailableMeetingRoomListing:
            return .get
        case .getDetailsOfMeetingRooms:
            return .get
        }
    }

    var body: Encodable? {
        switch self {
        case .myBookingListing:
            return nil
        case .getAvailableMeetingRoomListing(_, let requestModel):
            return requestModel
        case .getDetailsOfMeetingRooms(_, let requestModel):
            return requestModel
        }
    }
    

    var headers: [String : String]? {
        //APIManager.commonHeaders
        var commonHeaders = APIManager.commonHeaders
        return commonHeaders
    }
}
