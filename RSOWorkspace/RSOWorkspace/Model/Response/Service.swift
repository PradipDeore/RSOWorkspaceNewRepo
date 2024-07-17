//
//  Service.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 19/03/24.
//

import Foundation

struct ServiceResponse: Codable {
    let status: Bool
    let data: [Service]
}

struct Service: Codable {
    let id: Int
    let title: String
    let image: String
    let subServices: [SubService]
    // Custom decoding to handle parsing the JSON string into an array of SubService structs
    private enum CodingKeys: String, CodingKey {
        case id, title, image, sub_service
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        image = try container.decode(String.self, forKey: .image)
        
        let subServiceString = try container.decode(String.self, forKey: .sub_service)
        let jsonData = Data(subServiceString.utf8)
        subServices = try JSONDecoder().decode([SubService].self, from: jsonData)
    }
    // Custom encoding to handle encoding subServices into a JSON string
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(title, forKey: .title)
            try container.encode(image, forKey: .image)
            
            let jsonData = try JSONEncoder().encode(subServices)
            let subServiceString = String(data: jsonData, encoding: .utf8) ?? "[]"
            try container.encode(subServiceString, forKey: .sub_service)
        }
}

struct SubService: Codable {
    let id: Int
    let title: String
}
