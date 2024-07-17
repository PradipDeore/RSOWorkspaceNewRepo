//
//  BookingDetailsModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 12/03/24.
//

import Foundation
struct DisplayBookingDetailsModel {
    var meetingId: Int = 0
    var location : String = ""
    var date: String = Date.formatSelectedDate(format: .EEEEddMMMMyyyy, date: nil)
    var startTime: String = Date.formatSelectedDate(format: .hhmma, date: nil)
    var endTime: String = Date.formatSelectedDate(format: .hhmma, date: nil)
}
