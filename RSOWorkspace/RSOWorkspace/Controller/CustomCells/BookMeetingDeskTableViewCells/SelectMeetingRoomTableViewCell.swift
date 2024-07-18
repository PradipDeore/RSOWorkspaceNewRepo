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
        case loading
        case stopLoading
        case dataLoaded
        case error(Error)
    }
    
    var eventHandler: ((EventHandler) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false // Hide horizontal scroll indicator
    }
    
    func fetchmeetingRooms(id: Int, requestModel: BookMeetingRoomRequestModel) {
        self.eventHandler?(.loading)
        
        APIManager.shared.request(
            modelType: MeetingRoomListingResponse.self,
            type: MyBookingEndPoint.getAvailableMeetingRoomListing(id: id, requestModel: requestModel)) { [weak self] response in
                
                guard let self = self else { return }
                self.eventHandler?(.stopLoading)
                
                switch response {
                case .success(let responseData):
                    // Handle successful response with bookings
                    let roomList = responseData.data
                    let listItems: [RSOCollectionItem] = roomList.map { RSOCollectionItem(meetingRoomList: $0) }
                    self.collectionView.listItems = listItems
                    print("count of collection view list", self.collectionView.listItems.count)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                      RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    
    func fetchDesks(id: Int, requestModel: DeskRequestModel) {
        self.eventHandler?(.loading)
        
        APIManager.shared.request(
            modelType: DeskListingResponse.self,
            type: DeskBookingEndPoint.getDesksLisiting(id: id, requestModel: requestModel)) { [weak self] response in
                
                guard let self = self else { return }
                self.eventHandler?(.stopLoading)
                
                switch response {
                case .success(let responseData):
                    // Handle successful response with bookings
                    let deskList = responseData.data
                    let listItems: [RSOCollectionItem] = deskList.map { RSOCollectionItem(deskLisitngItem: $0) }
                    self.collectionView.listItems = listItems
                    print("count of collection view list",self.collectionView.listItems.count)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                      RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
   
}
