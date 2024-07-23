//
//  RSOMeetingRoomsCollectionView.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 26/02/24.
//

import Foundation
import UIKit

class RSOMeetingRoomsCollectionView: UICollectionView  {
    
    var backActionDelegate:BookButtonActionDelegate?
    var hideBookButton = false
    var listItems: [RSOCollectionItem] = []{
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
   
    var eventHandler: ((_ event: RoomListingViewController.Event) -> Void)?
    var isSearchEnabled = false
   
    // MARK: - Initializers
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        registerCells()
        dataSource = self
        delegate = self
    }
   
    private func registerCells() {
        register(UINib(nibName: "MeetingRoomsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MeetingRoomsCollectionViewCell")
        register(UINib(nibName: "DeskCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DeskCollectionViewCell")

    }

    var scrollDirection: UICollectionView.ScrollDirection = .vertical {
        didSet {
            if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = scrollDirection
            }
        }
    }
  
}

// MARK: - UICollectionViewDataSource

extension RSOMeetingRoomsCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = listItems[indexPath.row]
       
        guard let itemType = item.type else {
               fatalError("Item type is nil for item at index \(indexPath.row)")
           }
        switch item.type {
        case "room":
            let cell = dequeueReusableCell(withReuseIdentifier: "MeetingRoomsCollectionViewCell", for: indexPath) as! MeetingRoomsCollectionViewCell
            cell.backActionDelegate = backActionDelegate
            cell.setData(item: item)
            cell.tag = self.tag
            cell.btnBook.isHidden = hideBookButton
            return cell
        case "desk":
            let cell = dequeueReusableCell(withReuseIdentifier: "DeskCollectionViewCell", for: indexPath) as! DeskCollectionViewCell
            //cell.backActionDelegate = backActionDelegate

            cell.setData(item: item)
            return cell
        case "office":
            let cell = dequeueReusableCell(withReuseIdentifier: "DeskCollectionViewCell", for: indexPath) as! DeskCollectionViewCell
            //cell.backActionDelegate = backActionDelegate
            cell.setData(item: item)
            return cell
        default:
            fatalError("Unsupported item type: \(item.type ?? "nil")")
        }
    }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    for i in 0..<listItems.count {
            listItems[i].isItemSelected = false
        }
    listItems[indexPath.row].isItemSelected?.toggle()
    self.reloadData()
    backActionDelegate?.didSelect(selectedId: listItems[indexPath.row].id)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension RSOMeetingRoomsCollectionView: UICollectionViewDelegateFlowLayout {
    
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
