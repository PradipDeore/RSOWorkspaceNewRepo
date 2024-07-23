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
    case officeBooking(requestModel: BookOfficeRequestModel)
    case bookingDeskDetails(id : Int)
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
        case .officeBooking(requestModel: let requestModel):
            return "store-officebooking"
        case .bookingDeskDetails(id: let id):
            return "booking-desk-details/\(id)"
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
        case .officeBooking(requestModel: let requestModel):
            return .post
        case .bookingDeskDetails(id: let id):
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
        case .officeBooking(requestModel: let requestModel):
            return requestModel
        case .bookingDeskDetails(id: let id):
            return nil
        }
    }
    var headers: [String : String]? {
        //APIManager.commonHeaders
        var commonHeaders = APIManager.commonHeaders
        return commonHeaders
    }
}
