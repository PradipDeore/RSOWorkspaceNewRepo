//
//  RSOToken.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 22/02/24.
//

import Foundation
class RSOToken {
    static var shared = RSOToken()
    private init() {
    }
    func save(token:String){
        UserDefaults.standard.setValue(token, forKey: "Token")
    }
    func getToken()-> String?{
        let token = UserDefaults.standard.string(forKey: "Token")
        print("token is \(token)")
        return token
    }
}
