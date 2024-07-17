//
//  DashboardMeetingRoomsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 24/02/24.
//

import UIKit

class DashboardMeetingRoomsTableViewCell: UITableViewCell {
   
   
    @IBOutlet weak var collectionView: RSOMeetingRoomsCollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false // Hide horizontal scroll indicator
        fetchRooms()
    }

    func fetchRooms() {
        collectionView.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: ResponseData.self,
            type: DeskEndPoint.meetingRooms) { response in
                self.collectionView.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    let roomList = response.data
                    let listItems: [RSOCollectionItem] = roomList.map { RSOCollectionItem(meetingRoomItem: $0) }
                    self.collectionView.listItems = listItems
                    self.collectionView.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.collectionView.eventHandler?(.error(error))
                }
            }
    }
    func fetchOfficeDesk() {
        collectionView.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: OfficeItemsResponse.self,
            type: DeskBookingEndPoint.desks) { response in
                self.collectionView.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    let deskList = response.data
                    let listItems: [RSOCollectionItem] = deskList.map { RSOCollectionItem(deskItem: $0) }
                    self.collectionView.listItems = listItems
                    self.collectionView.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.collectionView.eventHandler?(.error(error))
                }
            }
    }
}
