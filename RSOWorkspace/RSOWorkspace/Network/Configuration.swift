//
//  Configuration.swift
//  RSOWorkspace
//
//  Created by Pradip on 05/10/24.
//

import Foundation
// Enum to represent different server environments
enum ServerEnvironment: String {
    case development = "https://rso.preproductiondemo.com/api/" //"https://finance.ardemos.co.in/rso-live-live/api/"
    case production = "https://rso.teamalo.com/api/"
    case live = "https://www.rsoworkplace.com/api/"
}

// Singleton Configuration class to manage base URL
class Configuration {
    // Shared instance for global access
    static let shared = Configuration()

    // The current environment (change this as needed)
    private var environment: ServerEnvironment = .development

    // Private initializer to prevent instantiation
    private init() {}

    // Getter for current base URL
    var baseURL: String {
        return environment.rawValue
    }

    // Method to update the environment dynamically if needed
    func setEnvironment(_ environment: ServerEnvironment) {
        self.environment = environment
    }
}
