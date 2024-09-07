//
//  SelectSeatingConfigTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 04/03/24.
//

import UIKit
import Kingfisher

protocol SelectSeatingConfigTableViewCellDelegate: AnyObject {
    func didSelectConfiguration(withId id: Int)
}

class SelectSeatingConfigTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    weak var delegate: SelectSeatingConfigTableViewCellDelegate?

    @IBOutlet weak var collectionView: UICollectionView!
    var confirmBookingDetails = ConfirmBookingRequestModel()
    // Data source for the collection view
    var sittingConfigurations: [ConfigurationDetails] = []
    var seatingConfigueId: Int = 0
    var selectedConfigId: Int?
    
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
       // return self.sittingConfigurations.count // show all item
        // Show only 1 item
        return min(sittingConfigurations.count, 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectSeatingConfigCollectionViewCell", for: indexPath) as! SelectSeatingConfigCollectionViewCell
        //old code
//            let configurationDetail = sittingConfigurations[indexPath.item]
//            let configurationImageURLString = imageBasePath + (configurationDetail.configurationImage ?? "")
//            seatingConfigueId = configurationDetail.configurationId ?? 0
//            if let configurationImageURL = URL(string: configurationImageURLString) {
//                cell.seatingConfigImage.kf.setImage(with: configurationImageURL)
//                
//            }
//            // Highlight the selected cell
//            if configurationDetail.configurationId == selectedConfigId {
//                cell.setSelected(true)
//            } else {
//                cell.setSelected(false)
//            }
        if indexPath.item == 0 {
                    // Display image for the first item
                    let configurationDetail = sittingConfigurations[indexPath.item]
                    let configurationImageURLString = imageBasePath + (configurationDetail.configurationImage ?? "")
                    seatingConfigueId = configurationDetail.configurationId ?? 0
                    if let configurationImageURL = URL(string: configurationImageURLString) {
                        cell.seatingConfigImage.kf.setImage(with: configurationImageURL)
                    }
                    // Highlight the selected cell
                    cell.isSelected = (configurationDetail.configurationId == selectedConfigId)
                } else {
                    // Optionally, you can hide or show a placeholder for non-visible cells
                    cell.seatingConfigImage.image = UIImage(named: "seatingConfig1")
                    cell.isHidden = true // Optionally hide non-visible cells
                }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedConfiguration = sittingConfigurations[indexPath.item]
            selectedConfigId = selectedConfiguration.configurationId
            
            // Notify the delegate about the selection
            delegate?.didSelectConfiguration(withId: selectedConfigId ?? 0)
            
            collectionView.reloadData() // Refresh to apply selection
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width - 20, height: 97)
        
    }
    
    
}
