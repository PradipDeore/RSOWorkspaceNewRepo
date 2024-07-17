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
    
    var scrollDirection: UICollectionView.ScrollDirection = .vertical {
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

// Delegate methods
extension RSOMarketPlaceCollectionView {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if scrollDirection == .vertical {
            return CGSize(width: bounds.width - 20, height: 225)
        } else {
            return CGSize(width: bounds.width - 50, height: 225)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}
