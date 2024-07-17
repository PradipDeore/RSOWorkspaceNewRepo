//
//  MarketPlaceViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/02/24.
//

import UIKit
import UIKit

class MarketPlaceViewController: UIViewController {
    
    @IBOutlet weak var collectionView: RSOMarketPlaceCollectionView!
    
    var listItems: [MarketPlaceItem] = [] {
        didSet {
            collectionView.listItems = listItems
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch marketplace data
        fetchMarketPlaces()
    }
    
    func fetchMarketPlaces() {
        collectionView.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: MarketPlaceResponse.self,
            type: DeskEndPoint.marketPlaces) { [weak self] response in
                self?.collectionView.eventHandler?(.stopLoading)
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

extension MarketPlaceViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
