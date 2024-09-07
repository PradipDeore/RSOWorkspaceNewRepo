//
//  SearchResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/08/24.
//

import Foundation

struct SearchResponseModel: Codable {
    let status: Bool?
    let rooms: [SearchRoomData]?
    let desks: [SearchDeskData]?
    let offices: [SearchOfficeData]?

    enum CodingKeys: String, CodingKey {
        case status
        case rooms = "Rooms"
        case desks = "Desks"
        case offices = "Offices"
    }
}

struct SearchRoomData: Codable {
    let id: Int?
    let roomName: String?
    let capacity: Int?
    let description: String?
    let roomImage: String?
    let roomPrice: String?
    let locationName:String?

    enum CodingKeys: String, CodingKey {
        case id
        case roomName = "room_name"
        case capacity
        case description
        case roomImage = "room_image"
        case roomPrice = "room_price"
        case locationName = "location_name"
    }
    
    // Custom decoding to parse the JSON string into an array
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        roomName = try container.decodeIfPresent(String.self, forKey: .roomName)
        capacity = try container.decodeIfPresent(Int.self, forKey: .capacity)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        roomImage = try container.decodeIfPresent(String.self, forKey: .roomImage)
        locationName = try container.decodeIfPresent(String.self, forKey: .locationName)
        roomPrice = try container.decodeIfPresent(String.self, forKey: .roomPrice)

        
    }
}

struct SearchRoomAmenityDetail: Codable {
    let roomAmenityName: String?

    enum CodingKeys: String, CodingKey {
        case roomAmenityName = "room_amenity_name"
    }
}



struct SearchDeskData: Codable {
    let id: Int?
    let name: String?
    let capacity: Int?
    let description: String?
    let image: String?
    let price: String?
    let type: String?
    let searchDeskamenityDetails: [SearchDeskAmenityDetail]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case capacity
        case description
        case image
        case price
        case type
        case searchDeskamenityDetails = "amenity_details"
    }

    
}
struct SearchDeskAmenityDetail: Codable {
    let amenityName: String?

    enum CodingKeys: String, CodingKey {
        case amenityName = "amenity_name"
    }
}
struct SearchOfficeData: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let capacity: Int?
    let price: String?
    let type: String?
    let searchOfficeamenityDetails: [searchOfficeAmenityDetail]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case capacity
        case price
        case type
        case searchOfficeamenityDetails = "amenity_details"
    }

}

struct searchOfficeAmenityDetail: Codable {
    let amenityName: String?

    enum CodingKeys: String, CodingKey {
        case amenityName = "amenity_name"
    }
}



//-------------------------------------------------

//struct SearchResponseModel: Codable {
//    let status: Bool?
//    let rooms: [SearchRoomData]?
//    let desks: [SearchDeskData]?
//    let offices: [SearchOfficeData]?
//
//    enum CodingKeys: String, CodingKey {
//        case status
//        case rooms = "Rooms"
//        case desks = "Desks"
//        case offices = "Offices"
//    }
//}
//
//struct SearchRoomData: Codable {
//    let id: Int?
//    let roomName: String?
//    let capacity: Int?
//    let description: String?
//    let roomImage: String?
//    let roomPrice: String?
//    let searchroomAmenityDetails: [SearchRoomAmenityDetail]?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case roomName = "room_name"
//        case capacity
//        case description
//        case roomImage = "room_image"
//        case roomPrice = "room_price"
//        case searchroomAmenityDetails = "room_amenity_details"
//    }
//    
//    // Custom decoding to parse the JSON string into an array
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decodeIfPresent(Int.self, forKey: .id)
//        roomName = try container.decodeIfPresent(String.self, forKey: .roomName)
//        capacity = try container.decodeIfPresent(Int.self, forKey: .capacity)
//        description = try container.decodeIfPresent(String.self, forKey: .description)
//        roomImage = try container.decodeIfPresent(String.self, forKey: .roomImage)
//        roomPrice = try container.decodeIfPresent(String.self, forKey: .roomPrice)
//
//        let amenityDetailsString = try container.decodeIfPresent(String.self, forKey: .searchroomAmenityDetails)
//        if let amenityDetailsData = amenityDetailsString?.data(using: .utf8) {
//            searchroomAmenityDetails = try? JSONDecoder().decode([SearchRoomAmenityDetail].self, from: amenityDetailsData)
//        } else {
//            searchroomAmenityDetails = nil
//        }
//    }
//}
//
//struct SearchRoomAmenityDetail: Codable {
//    let roomAmenityName: String?
//
//    enum CodingKeys: String, CodingKey {
//        case roomAmenityName = "room_amenity_name"
//    }
//}
//
//struct SearchDeskData: Codable {
//    let id: Int?
//    let name: String?
//    let capacity: Int?
//    let description: String?
//    let image: String?
//    let price: String?
//    let type: String?
//    let searchDeskamenityDetails: [SearchDeskAmenityDetail]?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case capacity
//        case description
//        case image
//        case price
//        case type
//        case searchDeskamenityDetails = "amenity_details"
//    }
//    
//    // Custom decoding to parse the JSON string into an array
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decodeIfPresent(Int.self, forKey: .id)
//        name = try container.decodeIfPresent(String.self, forKey: .name)
//        capacity = try container.decodeIfPresent(Int.self, forKey: .capacity)
//        description = try container.decodeIfPresent(String.self, forKey: .description)
//        image = try container.decodeIfPresent(String.self, forKey: .image)
//        price = try container.decodeIfPresent(String.self, forKey: .price)
//        type = try container.decodeIfPresent(String.self, forKey: .type)
//
//        let amenityDetailsString = try container.decodeIfPresent(String.self, forKey: .searchDeskamenityDetails)
//        if let amenityDetailsData = amenityDetailsString?.data(using: .utf8) {
//            searchDeskamenityDetails = try? JSONDecoder().decode([SearchDeskAmenityDetail].self, from: amenityDetailsData)
//        } else {
//            searchDeskamenityDetails = nil
//        }
//    }
//}
//struct SearchDeskAmenityDetail: Codable {
//    let amenityName: String?
//
//    enum CodingKeys: String, CodingKey {
//        case amenityName = "amenity_name"
//    }
//}
//struct SearchOfficeData: Codable {
//    let id: Int?
//    let name: String?
//    let image: String?
//    let capacity: Int?
//    let price: String?
//    let type: String?
//    let searchOfficeamenityDetails: [searchOfficeAmenityDetail]?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case image
//        case capacity
//        case price
//        case type
//        case searchOfficeamenityDetails = "amenity_details"
//    }
//    
//    // Custom decoding to parse the JSON string into an array
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decodeIfPresent(Int.self, forKey: .id)
//        name = try container.decodeIfPresent(String.self, forKey: .name)
//        image = try container.decodeIfPresent(String.self, forKey: .image)
//        capacity = try container.decodeIfPresent(Int.self, forKey: .capacity)
//        price = try container.decodeIfPresent(String.self, forKey: .price)
//        type = try container.decodeIfPresent(String.self, forKey: .type)
//
//        let amenityDetailsString = try container.decodeIfPresent(String.self, forKey: .searchOfficeamenityDetails)
//        if let amenityDetailsData = amenityDetailsString?.data(using: .utf8) {
//            searchOfficeamenityDetails = try? JSONDecoder().decode([searchOfficeAmenityDetail].self, from: amenityDetailsData)
//        } else {
//            searchOfficeamenityDetails = nil
//        }
//    }
//}
//
//struct searchOfficeAmenityDetail: Codable {
//    let amenityName: String?
//
//    enum CodingKeys: String, CodingKey {
//        case amenityName = "amenity_name"
//    }
//}
