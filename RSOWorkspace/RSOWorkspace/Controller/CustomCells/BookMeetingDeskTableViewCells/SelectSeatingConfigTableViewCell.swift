//
//  SelectSeatingConfigTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 04/03/24.
//

import UIKit
import Kingfisher

class SelectSeatingConfigTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var confirmBookingDetails = ConfirmBookingRequestModel()
    
    // Data source for the collection view
    var sittingConfigurations: [ConfigurationDetails] = []
    var seatingConfigueId: Int = 0

    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SelectSeatingConfigCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectSeatingConfigCollectionViewCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setData(sittingConfigurations: [ConfigurationDetails]){
        self.sittingConfigurations = sittingConfigurations
        
        self.collectionView.reloadData()
    }
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sittingConfigurations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectSeatingConfigCollectionViewCell", for: indexPath) as! SelectSeatingConfigCollectionViewCell
        let configurationDetail = sittingConfigurations[indexPath.item]
        // Load configuration image from URL using Kingfisher
        let configurationImageURLString = imageBasePath + (configurationDetail.configurationImage ?? "")
        seatingConfigueId = configurationDetail.configurationId ?? 0
        if let configurationImageURL = URL(string: configurationImageURLString) {
            cell.seatingConfigImage.kf.setImage(with: configurationImageURL)
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle item selection
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width - 20, height: 97)
        
    }
    
    
}
