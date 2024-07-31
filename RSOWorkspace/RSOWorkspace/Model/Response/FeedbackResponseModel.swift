//
//  FeedbackResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 30/07/24.
//

import Foundation

//https://finance.ardemos.co.in/rso/api/feedback-store?feedback_type=ffd&activity_name=fdfd&comments=fdff
struct FeedbackResponseModel: Codable {
    let status: Bool?
    let message: String?
}
