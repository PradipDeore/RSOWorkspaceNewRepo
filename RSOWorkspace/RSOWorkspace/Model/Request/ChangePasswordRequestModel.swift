//
//  ChangePasswordRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 30/07/24.
//

import Foundation
struct ChangePasswordRequestModel: Codable {
    let id: Int
    let confirm_password: String
    let new_password:String
}
