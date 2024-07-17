//
//  MyBookingRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 28/02/24.
//
//https://finance.ardemos.co.in/rso/api/booking-listing?type=all&limit=1
import Foundation

struct MyBookingRequestModel: Codable {
    let type: String
    let limit: Int
}

