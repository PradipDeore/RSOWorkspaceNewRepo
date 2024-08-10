//
//  BookMeetingRoomRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 08/03/24.
//

//https://finance.ardemos.co.in/rso/api/meeting-rooms-listing/1?date=2024-02-25&start_time=09:00&end_time=12:00&is_fullday=Yes

//https://finance.ardemos.co.in/rso/api/meeting-rooms/1?start_time=10:00&end_time=12:00&date=2024-08-10

import Foundation

struct BookMeetingRoomRequestModel: Codable {
    var date: String = Date.formatSelectedDate(format: .yyyyMMdd, date: nil)
    var startTime: String = Date.formatSelectedDate(format: .HHmm, date: nil)
    var endTime: String = Date.formatSelectedDate(format: .HHmm, date: nil)
    var isFullDay = "No"
    
    enum CodingKeys: String, CodingKey {
        case date
        case startTime = "start_time"
        case endTime = "end_time"
        case isFullDay = "is_fullday"
    }
}

struct MeetingRoomItemRequestModel:Codable{
    var date: String = Date.formatSelectedDate(format: .yyyyMMdd, date: nil)
    var start_time: String = Date.formatSelectedDate(format: .HHmm, date: nil)
    var end_time: String = Date.formatSelectedDate(format: .HHmm, date: nil)
}
