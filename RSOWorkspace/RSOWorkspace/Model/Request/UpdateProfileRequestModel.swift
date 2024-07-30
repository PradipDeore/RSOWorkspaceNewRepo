//
//  UpdateProfileRequestModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 11/04/24.
//

import Foundation

/*struct UpdateProfileRequestModel: Codable{
    var firstName: String?
    var lastName:String?
    var designation:String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case designation = "designation"
    }
}*/

struct UpdateProfileRequestModel: Codable{
    var first_name: String?
    var last_name:String?
    var designation:String?
    var photo :String?
}
