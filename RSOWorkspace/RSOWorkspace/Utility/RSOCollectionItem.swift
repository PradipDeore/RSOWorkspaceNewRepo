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
    let roomAmenityDetails: [RoomAmenities]?
    let roomAmenitiesDesk:[ListingAmenityDetail]?
    let officeAmenityDesk:[AmenityDetail]?
    let searchDeskAmenityDetails:[SearchDeskAmenityDetail]?
    let searchOfficeAmenityDetails:[searchOfficeAmenityDetail]?
    var isItemSelected: Bool?
    var deskId :Int?
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
        self.searchDeskAmenityDetails = []
        self.searchOfficeAmenityDetails = []
        self.type = "room"
        self.isItemSelected = false
    }
    // Initializer to convert from MeetingRoom
    init(meetingRoomList: MeetingRoomListing) {
        self.id = meetingRoomList.id
      self.roomName = meetingRoomList.roomName ?? ""
        self.capacity = meetingRoomList.capacity
        self.description = meetingRoomList.description
        self.roomImage = meetingRoomList.roomImage
        self.roomPrice = meetingRoomList.roomPrice
        self.roomAmenityDetails = meetingRoomList.roomAmenityDetails
        self.type = "room"
        self.locationName = nil
        self.roomAmenitiesDesk = []
        self.officeAmenityDesk = []
        self.searchDeskAmenityDetails = []
        self.searchOfficeAmenityDetails = []

        self.isItemSelected = false
    }
    // Initializer to convert from DeskItem
    init(deskItem: Office) {
        self.id = deskItem.id
        self.roomName = deskItem.name ?? ""
        self.capacity = deskItem.capacity
        self.description = nil
        self.roomImage = deskItem.image
        self.roomPrice = deskItem.price
        self.officeAmenityDesk = deskItem.amenityDetails
        self.roomAmenityDetails = nil
        self.type = "office"
        self.locationName = nil
        self.roomAmenitiesDesk = []
        self.searchDeskAmenityDetails = []
        self.searchOfficeAmenityDetails = []

        self.isItemSelected = false
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
        //self.type = deskLisitngItem.type
        self.type = "desk"
        self.roomAmenityDetails = nil
        self.officeAmenityDesk = []
        self.searchDeskAmenityDetails = []
        self.searchOfficeAmenityDetails = []

        self.isItemSelected = false
    }
    //search  room
    init(roomSearchListingItem: SearchRoomData) {
        self.id = roomSearchListingItem.id ?? 0
        self.roomName = roomSearchListingItem.roomName ?? ""
        self.capacity = roomSearchListingItem.capacity ?? 0
        self.description = roomSearchListingItem.description ?? ""
        self.roomImage = roomSearchListingItem.roomImage ?? ""
        self.roomPrice = roomSearchListingItem.roomPrice ?? "0"
        self.locationName = roomSearchListingItem.locationName
        self.searchDeskAmenityDetails = []
        self.searchOfficeAmenityDetails = []

        self.roomAmenitiesDesk = nil
        self.type = "room"
        self.roomAmenityDetails = nil
        self.officeAmenityDesk = []
        self.isItemSelected = false
    }
    //search desk
    init(deskSearchListingItem: SearchDeskData) {
        self.id = deskSearchListingItem.id ?? 0
        self.roomName = deskSearchListingItem.name ?? ""
        self.capacity = deskSearchListingItem.capacity ?? 0
        self.description = deskSearchListingItem.description ?? ""
        self.roomImage = deskSearchListingItem.image ?? ""
        self.roomPrice = deskSearchListingItem.price ?? "0"
        self.locationName = nil
        self.searchDeskAmenityDetails = deskSearchListingItem.searchDeskamenityDetails
        self.roomAmenitiesDesk = nil
        self.type = "desk"
        self.roomAmenityDetails = nil
        self.officeAmenityDesk = []
        self.searchOfficeAmenityDetails = []

        self.isItemSelected = false
    }
    //search office
    init(officeSearchListingItem: SearchOfficeData) {
        self.id = officeSearchListingItem.id ?? 0
        self.roomName = officeSearchListingItem.name ?? ""
        self.capacity = officeSearchListingItem.capacity ?? 0
        self.description = nil
        self.roomImage = officeSearchListingItem.image ?? ""
        self.roomPrice = officeSearchListingItem.price ?? "0"
        self.locationName = nil
        self.searchOfficeAmenityDetails = officeSearchListingItem.searchOfficeamenityDetails ?? []
        self.searchDeskAmenityDetails = []
        self.roomAmenitiesDesk = nil
        self.type = "office"
        self.roomAmenityDetails = nil
        self.officeAmenityDesk = []

        self.isItemSelected = false
    }
  // Initializer to convert from DeskListItem
  init(deskType: DeskType) {
    self.id = deskType.id ?? 0
    self.roomName = deskType.deskNo ?? ""
    self.isItemSelected = false
    self.capacity = 0
    self.description = ""
    self.roomImage = ""
    self.roomPrice = ""
    self.locationName = nil
    self.roomAmenitiesDesk = []
    self.type = "desk"
    self.deskId = deskType.deskID
    self.roomAmenityDetails = nil
    self.officeAmenityDesk = []
      self.searchDeskAmenityDetails = []
      self.searchOfficeAmenityDetails = []


  }
}
