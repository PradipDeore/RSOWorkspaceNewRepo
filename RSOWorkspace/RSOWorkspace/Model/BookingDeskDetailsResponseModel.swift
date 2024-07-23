//
//  BookingDeskDetailsResponseModel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/07/24.
//

import Foundation

// MARK: - BookingDeskDetailsResponseModel
struct BookingDeskDetailsResponseModel: Codable {
    let status: Bool
    let data: BookingData
    let members: [BookingDeskDetailsMember]
    let companies: [BookingDeskDetailsCompany]
    let interval: [Interval]
    let deskTypes: [DeskType]
    let amenities: [BookingDeskDetailsAmenity]
    let roomConfiguration: [RoomConfiguration]

    enum CodingKeys: String, CodingKey {
        case status, data, members, companies, interval
        case deskTypes = "desk_types"
        case amenities
        case roomConfiguration = "roomConfiguration"
    }
}

// MARK: - BookingData
struct BookingData: Codable {
    let id, memberId, companyId, deskTypeId: Int
    let startTime, endTime, date: String
    let intervalId: Int
    let vatAmount, totalPrice: String
    let totalMembers, totalHrs: Int
    let status, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case memberId = "member_id"
        case companyId = "company_id"
        case deskTypeId = "desk_type_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case date
        case intervalId = "interval_id"
        case vatAmount = "vat_amount"
        case totalPrice = "total_price"
        case totalMembers = "total_members"
        case totalHrs = "total_hrs"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Member
struct BookingDeskDetailsMember: Codable {
    let id: Int
    let firstName, lastName: String
    let photo: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo
    }
}

// MARK: - Company
struct BookingDeskDetailsCompany: Codable {
    let id: Int
    let accountType, name: String
    let logo: String?
    let locationId: Int
    let adminFname, adminLname, email: String
    let countryId: Int
    let phone, description: String
    let members, seats, floorId: Int
    let officeId, membershipTypeId: Int?
    let rewardPoints: Int
    let subscriptionStartDate, subscriptionEndDate, billingDate: String
    let isDeleted: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case accountType = "account_type"
        case name, logo
        case locationId = "location_id"
        case adminFname = "admin_fname"
        case adminLname = "admin_lname"
        case email
        case countryId = "country_id"
        case phone, description, members, seats
        case floorId = "floor_id"
        case officeId = "office_id"
        case membershipTypeId = "membership_type_id"
        case rewardPoints = "reward_points"
        case subscriptionStartDate = "subscription_start_date"
        case subscriptionEndDate = "subscription_end_date"
        case billingDate = "billing_date"
        case isDeleted = "is_deleted"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Interval
struct Interval: Codable {
    let id: Int
    let name: String
    let isDeleted: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case isDeleted = "is_deleted"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - DeskType
struct DeskType: Codable {
    let id: Int?
    let name: String?
    let isDeleted: Int?
    let createdAt, updatedAt, deskNo: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case isDeleted = "is_deleted"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deskNo
    }
}

// MARK: - Amenity
struct BookingDeskDetailsAmenity: Codable {
    let id: Int
    let name: String
    let isDeleted: Int
    let createdAt, updatedAt: String
    let amenitiesPrice: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case isDeleted = "is_deleted"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case amenitiesPrice = "amenities_price"
    }
}

// MARK: - RoomConfiguration
struct RoomConfiguration: Codable {
    let roomId: Int
    let roomName, roomConfigurationName, roomConfigurationImage: String
    let roomConfigurationId: Int

    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case roomName = "room_name"
        case roomConfigurationName = "room_configuration_name"
        case roomConfigurationImage = "room_configuration_image"
        case roomConfigurationId = "room_configuration_id"
    }
}
