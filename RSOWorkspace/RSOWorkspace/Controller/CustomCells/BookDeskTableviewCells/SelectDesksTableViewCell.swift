//
//  SelectDesksTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 12/04/24.
//

import UIKit

protocol SelectedDeskTableViewCellDelegate:AnyObject{
    func getselectedDeskNo(selectedDeskNo:[Int])
    func viewFloorPlan()
}
class SelectDesksTableViewCell: UITableViewCell , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: SelectedDeskTableViewCellDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedDeskNo:[Int] = [1,2,3]
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
        return 4/* Your number of items */
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue your custom cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectDeskCollectionViewCell", for: indexPath) as! SelectDeskCollectionViewCell
       
        if indexPath.item % 2 == 0 {
            cell.deskNoView.backgroundColor = .black
            cell.lblDeskNo.textColor = .white
        } else {
            cell.deskNoView.backgroundColor = .white
            cell.lblDeskNo.textColor = .black
        }
        cell.lblDeskNo.text = "C\(indexPath.item + 1) "
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SelectDeskCollectionViewCell {
            let selectedDeskNumber = cell.lblDeskNo.text
           // print("Selected desk number: \(String(describing: selectedDeskNumber))")
            //self.selectedDeskNo = selectedDeskNumber ?? ""
             //delegate?.getselectedDeskNo(selectedDeskNo: selectedDeskNumber)
        }
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
