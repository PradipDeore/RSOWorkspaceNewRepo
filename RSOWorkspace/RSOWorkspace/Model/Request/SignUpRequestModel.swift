//
//  SignUpRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 22/02/24.
//

import Foundation
struct SignUpRequestModel: Codable {
    let email: String
    let password: String
    let phone : String
}
