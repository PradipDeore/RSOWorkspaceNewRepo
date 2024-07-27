//
//  SelectMeetingRoomTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/03/24.
//

import UIKit


class SelectMeetingRoomTableViewCell: UITableViewCell {
  
  @IBOutlet weak var collectionView: RSOMeetingRoomsCollectionView!
  var selectedMeetingRoom :RSOCollectionItem?
  
  var meetingId: Int = 0 {
    didSet {
      if meetingId > 0 {
        self.collectionView.listItems = self.collectionView.listItems.filter { $0.id == self.meetingId }
      }
      print("count of collection view list", self.collectionView.listItems.count)
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  
  enum EventHandler {
    case dataLoaded
    case error(Error)
  }
  
  var eventHandler: ((EventHandler, _ listItems: [RSOCollectionItem]? ) -> Void)?
 
    override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    collectionView.scrollDirection = .horizontal
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false // Hide horizontal scroll indicator
  }
  
  func fetchmeetingRooms(id: Int, requestModel: BookMeetingRoomRequestModel) {
    
    APIManager.shared.request(
      modelType: MeetingRoomListingResponse.self,
      type: MyBookingEndPoint.getAvailableMeetingRoomListing(id: id, requestModel: requestModel)) { [weak self] response in
        DispatchQueue.main.async {
          guard let self = self else { return }
          
          switch response {
          case .success(let responseData):
            // Handle successful response with bookings
            let roomList = responseData.data
            let listItems: [RSOCollectionItem] = roomList.map { RSOCollectionItem(meetingRoomList: $0) }
            self.collectionView.listItems = listItems
            print("count of collection view list", self.collectionView.listItems.count)
            self.collectionView.reloadData()
            self.eventHandler?(.dataLoaded, listItems)
          case .failure(let error):
            self.eventHandler?(.error(error), nil)
            RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
          }
        }
      }
  }
  
  func fetchDesks(id: Int, requestModel: DeskRequestModel) {
    APIManager.shared.request(
      modelType: DeskListingResponse.self,
      type: DeskBookingEndPoint.getDesksLisiting(id: id, requestModel: requestModel)) { [weak self] response in
          DispatchQueue.main.async {
        guard let self = self else { return }
        switch response {
        case .success(let responseData):
          // Handle successful response with bookings
          let deskList = responseData.data
          let listItems: [RSOCollectionItem] = deskList.map { RSOCollectionItem(deskLisitngItem: $0) }
          self.collectionView.listItems = listItems
          print("count of collection view list",self.collectionView.listItems.count)
            self.collectionView.reloadData()
          self.eventHandler?(.dataLoaded, listItems)
        case .failure(let error):
          self.eventHandler?(.error(error), nil)
            RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
          }
        }
      }
  }
    
    func fetchOfficeDesk(id: Int, requestModel: BookOfficeRequestModel) {
      DispatchQueue.main.async {
        RSOLoader.showLoader()
      }
        APIManager.shared.request(
            modelType: OfficeItemsResponse.self,
            type: DeskBookingEndPoint.offices(id: id, requestModel: requestModel)) { response in
              DispatchQueue.main.async {
                RSOLoader.removeLoader()
              }
                switch response {
                case .success(let response):
                  if let officeList = response.data {
                    let listItems: [RSOCollectionItem] = officeList.map { RSOCollectionItem(deskItem: $0) }
                    self.collectionView.listItems = listItems
                      DispatchQueue.main.async {
                        self.collectionView.reloadData()
                      }
                      self.eventHandler?(.dataLoaded, listItems)
                  }
                case .failure(let error):
                    self.eventHandler?(.error(error), nil)
                    DispatchQueue.main.async {
                      RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
  
}
