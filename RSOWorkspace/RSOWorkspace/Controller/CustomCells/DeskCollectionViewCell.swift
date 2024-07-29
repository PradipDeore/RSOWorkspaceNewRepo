//
//  DeskCollectionViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 20/02/24.
//

import UIKit
import Kingfisher
protocol DeskBookButtonActionDelegate:AnyObject{
    func showBookRoomDetailsVC(meetingRoomId: Int)
    func showDeskBookingVC()
    func showLogInVC()
}
class DeskCollectionViewCell: UICollectionViewCell {
    
    weak var backActionDelegate: DeskBookButtonActionDelegate?
    
    @IBOutlet weak var btnBook: RSOButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lbldeskName: UILabel!
    @IBOutlet weak var lblNoOfPeople: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgRoomImage: UIImageView!
    
    var cornerRadius: CGFloat = 10.0
    var roomName = ""
    var selectedMeetingRoom = 0
    
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
        if item.type == "office" {
            self.lblDescription.text = "Conference Phone"
        } else {
            self.lblDescription.text = item.description
        }
        
        self.lblPrice.text = "\(item.roomPrice!) /Hr"
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
            if self.tag == 1{
                backActionDelegate?.showBookRoomDetailsVC(meetingRoomId: selectedMeetingRoom)
            }else{
                backActionDelegate?.showDeskBookingVC()
                
            }
        }else {
            backActionDelegate?.showLogInVC()
        }
    }
}

