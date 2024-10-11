//
//  RSOMarketPlaceCollectionView.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 24/02/24.
//

import Foundation
import UIKit

class RSOMarketPlaceCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    
    var listItems: [MarketPlaceItem] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    var eventHandler: ((_ event: MarketPlaceViewController.Event) -> Void)?
    
    var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet {
            if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = scrollDirection
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        register(UINib(nibName: "MarketPlaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MarketPlaceCollectionViewCell")
        
        delegate = self
        dataSource = self
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = scrollDirection
        }
    }
}

extension RSOMarketPlaceCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "MarketPlaceCollectionViewCell", for: indexPath) as! MarketPlaceCollectionViewCell
        let item = listItems[indexPath.item]
        cell.customizeCell()
        cell.setData(item: item)
        return cell
    }
}
extension RSOMarketPlaceCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = listItems[indexPath.item]
        
        // Check if the URL is available and valid
        if let urlString = selectedItem.link, let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            // Open the URL
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Optionally handle the case where the URL is invalid or unavailable
            print("Invalid URL or URL not available for the selected item")
        }
    }
}

// Delegate methods
extension RSOMarketPlaceCollectionView {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if scrollDirection == .vertical {
            return CGSize(width: bounds.width - 20, height: 200)
        } else {
            return CGSize(width: bounds.width - 50, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}
