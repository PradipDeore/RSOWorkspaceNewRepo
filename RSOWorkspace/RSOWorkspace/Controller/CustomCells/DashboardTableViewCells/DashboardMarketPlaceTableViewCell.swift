//
//  DashboardMarketPlaceTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 24/02/24.
//

import UIKit

class DashboardMarketPlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: RSOMarketPlaceCollectionView!
    var listItems: [MarketPlaceItem] = [] {
        didSet {
            collectionView.listItems = listItems
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false // Hide horizontal scroll indicator

        fetchMarketPlaces()
    }
    
    func fetchMarketPlaces() {
        APIManager.shared.request(
            modelType: MarketPlaceResponse.self,
            type: DeskEndPoint.marketPlaces) { [weak self] response in
                switch response {
                case .success(let response):
                    self?.listItems = response.data
                    self?.collectionView.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self?.collectionView.eventHandler?(.error(error))
                }
            }
    }
}
