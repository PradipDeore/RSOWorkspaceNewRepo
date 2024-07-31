//
//  SocialLoginResponse.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 31/07/24.
//

import Foundation
//https://finance.ardemos.co.in/rso/api/social-login?auth_type=google&auth_id=1234567890

struct SocialLoginResponse: Codable {
    let status: Bool?
    let token: String?
    let message:String?
}
