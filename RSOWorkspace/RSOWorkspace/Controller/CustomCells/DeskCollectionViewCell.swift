//
//  DeskCollectionViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 20/02/24.
//

import UIKit
import Kingfisher

class DeskCollectionViewCell: UICollectionViewCell {
    //BookButtonActionDelegate
    weak var backActionDelegate: BookButtonActionDelegate?
    
    @IBOutlet weak var btnBook: RSOButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lbldeskName: UILabel!
    @IBOutlet weak var lblNoOfPeople: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgRoomImage: UIImageView!
    
    @IBOutlet weak var viewAmenityDetails: UIButton!
    var cornerRadius: CGFloat = 10.0
    var roomName = ""
    var selectedMeetingRoom = 0
    var itemType = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
    }
    
    func customizeCell(){
        self.btnBook.layer.cornerRadius = btnBook.bounds.height / 2
        
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        
        let shadowColor = UIColor.black.withAlphaComponent(0.5)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 19.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:  CGRect(x: 0, y: self.bounds.height - 4, width: self.bounds.width, height: 4), cornerRadius: self.containerView.layer.cornerRadius).cgPath
        self.containerView.backgroundColor =  .white
    }
    func setData(item : RSOCollectionItem){
        //print("Item type: \(item.type ?? "nil")") // Debug print for item type
        selectedMeetingRoom = item.id
        self.lbldeskName.text = item.roomName
        self.lblNoOfPeople.text = "\(item.capacity!) Person"
        self.itemType = item.type ?? ""
        
        if item.type == "office" {
            if let price = item.roomPrice {
                self.lblPrice.text = "\(price) /Hr"
            } else {
                self.lblPrice.text = "0 /Hr"
            }
            self.lblDescription.text = "Conference Phone"
           
        } else {
            self.lblDescription.text = item.description
        }
        
        if item.type == "desk" {
            if let price = item.roomPrice {
                self.lblPrice.text = "\(price) /Day"
            } else {
                self.lblPrice.text = "0 /Day"
            }
        }
        if let imageUrl = item.roomImage, !imageUrl.isEmpty {
            let url = URL(string: imageBasePath + imageUrl)
            self.imgRoomImage.kf.setImage(with: url)
        }
        if self.tag == 1 {
            self.btnBook.isHidden = false
            
        }
    }
    @IBAction func btnBookTappedAction(_ sender: Any) {
        if let _ = RSOToken.shared.getToken() {
            let currentTime = Date()
            if itemType == "office"{
                if UserHelper.shared.getSavedStartTime() == UserHelper.shared.getSavedEndTime(){
                    self.contentView.makeToast("start time and end time must not be same !")
                }else {
                    backActionDelegate?.showShortTermOfficeBookingVC()
                }
            }else{
                backActionDelegate?.showDeskBookingVC()
            }
        }else {
            backActionDelegate?.showLogInVC()
        }
    }
   
    @IBAction func btnViewamenityDetailsAction(_ sender: Any) {
        
    }
}

