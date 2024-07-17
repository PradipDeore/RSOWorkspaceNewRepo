//
//  RSOCollectionItem.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 11/03/24.
//

import Foundation
struct RSOCollectionItem: Codable {
    let id: Int
    let roomName: String
    let capacity: Int?
    let description: String?
    let roomImage: String?
    let roomPrice: String?
    let locationName: String?
    let type : String?
    let roomAmenityDetails: String?
    let roomAmenitiesDesk:[ListingAmenityDetail]
    let officeAmenityDesk:[AmenityDetail]
    
    // Initializer to convert from MeetingRoomsItem
    init(meetingRoomItem: MeetingRoomsItem) {
        self.id = meetingRoomItem.id
        self.roomName = meetingRoomItem.roomName
        self.capacity = meetingRoomItem.capacity
        self.description = meetingRoomItem.description
        self.roomImage = meetingRoomItem.roomImage
        self.roomPrice = meetingRoomItem.roomPrice
        self.locationName = meetingRoomItem.locationName
        self.roomAmenityDetails = meetingRoomItem.roomAmenityDetails
        self.roomAmenitiesDesk = []
        self.officeAmenityDesk = []
        self.type = "room"
    }
    // Initializer to convert from MeetingRoom
    init(meetingRoomList: MeetingRoomListing) {
        self.id = meetingRoomList.id
        self.roomName = meetingRoomList.name
        self.capacity = meetingRoomList.capacity
        self.description = meetingRoomList.description
        self.roomImage = meetingRoomList.image
        self.roomPrice = meetingRoomList.price
        self.roomAmenityDetails = meetingRoomList.amenityDetails
        self.type = meetingRoomList.type
        self.locationName = nil
        self.roomAmenitiesDesk = []
        self.officeAmenityDesk = []
    }
    // Initializer to convert from DeskItem
    init(deskItem: Office) {
        self.id = deskItem.id
        self.roomName = deskItem.name
        self.capacity = deskItem.capacity
        self.description = nil
        self.roomImage = deskItem.image
        self.roomPrice = deskItem.price
        self.officeAmenityDesk = deskItem.amenityDetails
        self.roomAmenityDetails = nil
        self.type = deskItem.type
        self.locationName = nil
        self.roomAmenitiesDesk = []

    }
    // Initializer to convert from DeskListItem
    init(deskLisitngItem: DeskListingItem) {
        self.id = deskLisitngItem.id
        self.roomName = deskLisitngItem.name
        self.capacity = deskLisitngItem.capacity
        self.description = deskLisitngItem.description
        self.roomImage = deskLisitngItem.image
        self.roomPrice = deskLisitngItem.price
        self.locationName = nil
        self.roomAmenitiesDesk = deskLisitngItem.amenityDetails
        self.type = deskLisitngItem.type
        self.roomAmenityDetails = nil
        self.officeAmenityDesk = []
    }
}
