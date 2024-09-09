//
//  ConfirmOfficeBookingDetailsModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 27/07/24.
//

import Foundation

struct ConfirmOfficeBookingDetailsModel {
    var officeId: Int = 0
    var officeName : String = ""
    var location : String = ""
    var date: String = Date.formatSelectedDate(format: .EEEEddMMMMyyyy, date: nil)
    var startTime: String = Date.formatSelectedDate(format: .hhmma, date: nil)
    var endTime: String = Date.formatSelectedDate(format: .hhmma, date: nil)
    var nofOfSeats: Int = 0
}
