//
//  PaymentRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 14/03/24.
//

import Foundation
struct PaymentRequestModel{
    var meetingId: Int = 0
    var meetingRoom: String = ""
    var price:String = ""
    var time: String? = ""
    var amenities:[String?] = []
    var amenitiesPrice: String = ""
}

//BookMeetingID
//BookdeskID
//BookOfficeID
struct NiPaymentRequestModel: Codable {
    var total: Double?
    var email: String?
    var BookMeetingID:String?
    var BookdeskID:String?
    var BookOfficeID:String?
   
    init() {
        self.total = 0
        self.email = ""
        self.BookMeetingID = ""
        self.BookdeskID = ""
        self.BookOfficeID = ""
    }
}
