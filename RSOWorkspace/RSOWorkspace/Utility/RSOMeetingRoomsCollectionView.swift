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
    var freeamenityArray: [AmenityFree] = [] // Add this property
    var freeamenityArrayDesk: [BookingDeskDetailsFreeAmenity] = [] // Add this property
    var currentScreen: String? // e.g., "RoomDetailsScreen", "OtherScreen"
    var currentViewController:UIViewController?
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
        guard indexPath.row < listItems.count else {
              fatalError("Index out of range. List items count: \(listItems.count), IndexPath row: \(indexPath.row)")
          }
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
            cell.backActionDelegate = backActionDelegate
            cell.setData(item: item)
            cell.btnBook.isHidden = hideBookButton
          if item.isItemSelected ?? false {
            cell.containerView.backgroundColor = UIColor(named: "E3E3E3")
          } else {
            cell.containerView.backgroundColor = .white
          }
            return cell
        case "office":
            let cell = dequeueReusableCell(withReuseIdentifier: "DeskCollectionViewCell", for: indexPath) as! DeskCollectionViewCell
           cell.backActionDelegate = backActionDelegate
            cell.setData(item: item)
            cell.tag = self.tag
            cell.btnBook.isHidden = hideBookButton
            if item.isItemSelected ?? false {
              cell.containerView.backgroundColor = UIColor(named: "E3E3E3")
            } else {
              cell.containerView.backgroundColor = .white
            }
            return cell
        default:
            fatalError("Unsupported item type: \(item.type ?? "nil")")
        }
    }
//  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////    let item = listItems[indexPath.row]
////   
////    guard let itemType = item.type,  item.type == "desk" || itemType == "office" else {
////           return
////       }
////    for i in 0..<listItems.count {
////            listItems[i].isItemSelected = false
////        }
////    listItems[indexPath.row].isItemSelected?.toggle()
////    self.reloadData()
////    backActionDelegate?.didSelect(selectedId: listItems[indexPath.row].id)
//      let item = listItems[indexPath.row]
//          
//          guard let itemType = item.type else {
//              return
//          }
//          
//      if itemType == "room" {
//          // Create an alert controller
//              let selectedAmenities = freeamenityArray // Assuming this is set correctly
//              print("Free amenities: \(selectedAmenities)")
//              
//              let alertController = UIAlertController(title: "Room Information", message:nil, preferredStyle: .alert)
//              // Create the bullet points for the amenities
//              var message = ""
//              for amenity in selectedAmenities {
//                  let name = amenity.name ?? "No Name"
//                  let description = amenity.description ?? "No Description"
//                  
//                  // Append each amenity with titles for name and description
//                  message.append("• Amenity Name: \(name)\n")
//                  message.append("  Description: \(description)\n\n")
//              }
//              alertController.message = message
//              
//              // Add a Cancel action
//              let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//              alertController.addAction(cancelAction)
//              // Present the alert controller
//              if let parentVC = self.parentViewController {
//                  parentVC.present(alertController, animated: true, completion: nil)
//              } else {
//                  print("Parent view controller is nil. Unable to present alert.")
//              }
//          
//      }else if itemType == "desk" || itemType == "office" {
//              // Handle selection of desk or office items as before
//              for i in 0..<listItems.count {
//                  listItems[i].isItemSelected = false
//              }
//              listItems[indexPath.row].isItemSelected?.toggle()
//              self.reloadData()
//              backActionDelegate?.didSelect(selectedId: listItems[indexPath.row].id)
//          }
//  }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = listItems[indexPath.row]
        
        guard let itemType = item.type else {
            return
        }
        
        if itemType == "room" {
            // Show the alert for room amenities
            if let viewController = self.currentViewController, viewController is BookRoomDetailsViewController{
                viewController.showAmenitiesAlert(amenities: freeamenityArray, title: "Room Information")
            }
            
        } else if itemType == "desk" {
            print("Selected desk item: \(item)")
            // Handle selection of desk items
            handleSelection(for: indexPath)
            
        } else if itemType == "office" {
            // Handle selection of office items
            handleSelection(for: indexPath)
        }
    }

    // Helper function to handle item selection
    private func handleSelection(for indexPath: IndexPath) {
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

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}
