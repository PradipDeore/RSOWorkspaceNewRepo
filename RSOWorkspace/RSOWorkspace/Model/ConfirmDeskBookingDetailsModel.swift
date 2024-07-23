//
//  ConfirmDeskBookingDetailsModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/04/24.
//

import Foundation
struct ConfirmDeskBookingDetailsModel {
    var deskId: Int = 0
    var location : String = ""
    var date: String = Date.formatSelectedDate(format: .EEEEddMMMMyyyy, date: nil)
    var startTime: String = Date.formatSelectedDate(format: .hhmma, date: nil)
    var endTime: String = Date.formatSelectedDate(format: .hhmma, date: nil)
    var teamMembersArray:[String] = []
    var selected_desk_no:[Int] = []
}
