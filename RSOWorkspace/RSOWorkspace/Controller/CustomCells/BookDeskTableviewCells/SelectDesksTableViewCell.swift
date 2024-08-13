//
//  SelectDesksTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 12/04/24.
//

import UIKit

protocol SelectedDeskTableViewCellDelegate:AnyObject{
    func getselectedDeskNo(selectedDeskNo: [Int], selectedDeskList: [RSOCollectionItem])
    func viewFloorPlan()
}
class SelectDesksTableViewCell: UITableViewCell , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: SelectedDeskTableViewCellDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    var deskList:[RSOCollectionItem] = []
    var shouldSelectable = true

    @IBOutlet weak var btnViewFloorPlan: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Register custom cell
        collectionView.register(UINib(nibName: "SelectDeskCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectDeskCollectionViewCell")
        
        // Set up collection view properties
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items in your collection view
        return deskList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue your custom cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectDeskCollectionViewCell", for: indexPath) as! SelectDeskCollectionViewCell
        let desk = deskList[indexPath.row]
        if desk.isItemSelected ?? false {
            cell.deskNoView.backgroundColor = .black
            cell.lblDeskNo.textColor = .white
        } else {
            cell.deskNoView.backgroundColor = .white
            cell.lblDeskNo.textColor = .black
        }
        cell.lblDeskNo.text = desk.roomName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           guard shouldSelectable else { return }
           deskList[indexPath.row].isItemSelected?.toggle()
           self.collectionView.reloadData()
           let selectedDeskListing = deskList.filter({ $0.isItemSelected ?? false })
           let selectedIDs = selectedDeskListing.map( { $0.id })
           delegate?.getselectedDeskNo(selectedDeskNo: selectedIDs, selectedDeskList: selectedDeskListing)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = 95
        let height: CGFloat = 50
        return CGSize(width: width , height: height)
    }
    
    @IBAction func btnViewFloorPlan(_ sender: Any) {
        delegate?.viewFloorPlan()
    }
    
}
