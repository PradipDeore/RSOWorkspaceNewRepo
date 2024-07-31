//
//  SocailLoginRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 31/07/24.
//

import Foundation
//https://finance.ardemos.co.in/rso/api/social-login

struct SocailLoginRequestModel: Codable {
    let auth_type: String
    let auth_id:String
}
