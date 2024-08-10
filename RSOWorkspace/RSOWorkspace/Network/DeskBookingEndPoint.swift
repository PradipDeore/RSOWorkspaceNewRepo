//
//  DeskBookingEndPoint.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/04/24.
//

import Foundation

enum DeskBookingEndPoint {
    case offices(id: Int?, requestModel: BookOfficeRequestModel?)
    case getDesksLisiting(id: Int, requestModel: DeskRequestModel)
    case getDetailsOfMeetingRooms(id: Int, requestModel: BookMeetingRoomRequestModel)
    case DeskDetails(deskId : Int)
    case storeDeskBooking(requestModel: StoreDeskBookingRequest)
}
extension DeskBookingEndPoint: EndPointType {

    var path: String {
        switch self {
        case .offices(let id ,_):
            //https://finance.ardemos.co.in/rso/api/office-listing/1?start_time=11:00&end_time=13:00&date=2024-01-31&is_fullday=Yes
            if let locationId = id {
              return "office-listing/\(locationId)"
            } else {
                return "office-listing/1"
            }
        case .getDesksLisiting(let id ,_):
            return "desk-listing/\(id)"
        case .getDetailsOfMeetingRooms(let id ,_):
            
            return "room-details/\(id)"
        //https://finance.ardemos.co.in/rso/api/desk-details/2
        case .DeskDetails(deskId: let deskId):
            return "desk-details/\(deskId)"
        case .storeDeskBooking(requestModel: let requestModel):
            return "store-deskbooking"
        }
    }
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .offices:
            return .get
        case .getDesksLisiting:
            return .get
        case .getDetailsOfMeetingRooms:
            return .get
        case .DeskDetails(deskId: let deskId):
            return .get
        case .storeDeskBooking(requestModel: let requestModel):
            return .post
        }
    }

    var body: Encodable? {
        switch self {
        case .offices(_, let requestModel):
            return requestModel
        case .getDesksLisiting(_, let requestModel):
            return requestModel
        case .getDetailsOfMeetingRooms(_, let requestModel):
            return requestModel
        case .DeskDetails(deskId: let deskId):
            return nil
        case .storeDeskBooking(requestModel: let requestModel):
            return requestModel
        }
    }
    

    var headers: [String : String]? {
        //APIManager.commonHeaders
        let commonHeaders = APIManager.commonHeaders
        return commonHeaders
    }
}
