//
//  DisplayScheduleVisitorsDetailModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 10/04/24.
//

import Foundation

struct DisplayScheduleVisitorsDetailModel {
    var date: String = Date.formatSelectedDate(format: .EEEEddMMMMyyyy, date: nil)
    var startTime: String = Date.formatSelectedDate(format: .hhmma, date: nil)
    var endTime: String = Date.formatSelectedDate(format: .hhmma, date: nil)
    var reasonForVisit: String = ""
    var visitors : [MyVisitorDetail] = []
}

struct DisplayScheduleVisitorsEditDetailModel {
    var date: String = Date.formatSelectedDate(format: .EEEEddMMMMyyyy, date: nil)
    var startTime: String = Date.formatSelectedDate(format: .hhmma, date: nil)
    var endTime: String = Date.formatSelectedDate(format: .hhmma, date: nil)
    var reasonForVisit: String = ""
    var visitors : [MyVisitorDetail] = []
}
