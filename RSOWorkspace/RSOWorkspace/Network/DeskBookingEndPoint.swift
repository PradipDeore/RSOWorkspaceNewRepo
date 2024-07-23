//
//  DeskBookingEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/04/24.
//

import Foundation

enum DeskBookingEndPoint {
    case desks
    case getDesksLisiting(id: Int, requestModel: DeskRequestModel)
    case getDetailsOfMeetingRooms(id: Int, requestModel: BookMeetingRoomRequestModel)
    case bookingDeskDetails(id : Int)
}
extension DeskBookingEndPoint: EndPointType {

    var path: String {
        switch self {
        case .desks:
            return "office-listing/1"   //https://finance.ardemos.co.in/rso/api/office-listing/1?start_time=11:00&end_time=13:00&date=2024-01-31&is_fullday=Yes
        case .getDesksLisiting(let id ,_):
            return "desk-listing/\(id)"
        case .getDetailsOfMeetingRooms(let id ,_):
            return "room-details/\(id)"
        case .bookingDeskDetails(id: let id):
            return "booking-desk-details/\(id)"
        }
    }
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .desks:
            return .get
        case .getDesksLisiting:
            return .get
        case .getDetailsOfMeetingRooms:
            return .get
        case .bookingDeskDetails(id: let id):
            return .get
        }
    }

    var body: Encodable? {
        switch self {
        case .desks:
            return nil
        case .getDesksLisiting(_, let requestModel):
            return requestModel
        case .getDetailsOfMeetingRooms(_, let requestModel):
            return requestModel
        case .bookingDeskDetails(id: let id):
            return nil
        }
    }
    

    var headers: [String : String]? {
        //APIManager.commonHeaders
        let commonHeaders = APIManager.commonHeaders
        return commonHeaders
    }
}
