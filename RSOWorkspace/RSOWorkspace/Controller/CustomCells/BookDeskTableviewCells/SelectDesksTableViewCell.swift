//
//  SelectDesksTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 12/04/24.
//

import UIKit

class SelectDesksTableViewCell: UITableViewCell , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
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
           cell.customizeCell()
           // Set alternating background colors based on index
               if indexPath.item % 2 == 0 {
                   // Even index: black background
                   cell.deskNoView.backgroundColor = .black
                   cell.lblDeskNo.textColor = .white
               } else {
                   // Odd index: white background
                   cell.deskNoView.backgroundColor = .white

               }
           return cell
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let selectedItem =
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let width:CGFloat = 95
        let height: CGFloat = 60 // Height of the item
        return CGSize(width: width , height: height)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//    }

   }
