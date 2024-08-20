//
//  MeetingRoomsCollectionViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/03/24.
//

import UIKit
import Kingfisher

protocol BookButtonActionDelegate:AnyObject{
    func showBookRoomDetailsVC(meetingRoomId: Int)
    func showBookMeetingRoomsVC()
    func showLogInVC()
    func showDeskBookingVC()
    func showShortTermOfficeBookingVC()
    func didSelect(selectedId: Int)
}
extension BookButtonActionDelegate {
  func didSelect(selectedId: Int) {
  }
    func showDeskBookingVC(){}
    func showShortTermOfficeBookingVC(){}
}
class MeetingRoomsCollectionViewCell: UICollectionViewCell {
    
    var isAmenitiesScreen = false

    weak var backActionDelegate: BookButtonActionDelegate?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgroomImage: UIImageView!
    @IBOutlet weak var lblroomName: UILabel!
    @IBOutlet weak var lblnoofCapacity: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblroomPrice: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    var cornerRadius: CGFloat = 10.0
    var selectedMeetingRoom: Int?
    @IBOutlet weak var btnBook: UIButton!
    
    @IBOutlet weak var meetingRoomDashboardView: UIView!
    @IBOutlet weak var bookMeetingRoomView: UIView!
    
    @IBOutlet weak var noOfPeople: UILabel!
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customizeCell()
        self.meetingRoomDashboardView.isHidden = false
        self.bookMeetingRoomView.isHidden = false
        self.btnBook.isHidden = false
        self.isAmenitiesScreen = true

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
    }
    func setData(item : RSOCollectionItem){
        self.selectedMeetingRoom = item.id
        self.lblroomName.text = item.roomName
        self.lblnoofCapacity.text = "\(item.capacity ?? 0) People"
        self.lblLocation.text = item.locationName
        self.lblroomPrice.text = "\(item.roomPrice ?? "0") /Hr"
        //let amenityDetails = item.amenityDetails
        print("setData for room")
        print("name for room=", item.roomName)
        print("name for price=", item.roomPrice)
        if let imageUrl = item.roomImage, !imageUrl.isEmpty {
            let url = URL(string: imageBasePath + imageUrl)
            self.imgroomImage.kf.setImage(with: url)
        }
        if self.tag == 1 {
            self.meetingRoomDashboardView.isHidden = true
            self.bookMeetingRoomView.isHidden = false
            self.btnBook.isHidden = false

        }else{
            self.bookMeetingRoomView.isHidden = true
            self.meetingRoomDashboardView.isHidden = false
            self.btnBook.isHidden = false

        }
    }

    
    @IBAction func btnBookTappedAction(_ sender: Any) {
       if let _ = RSOToken.shared.getToken() {
            if self.tag == 1{
                print("book button tag is bookroom details",self.tag)

                backActionDelegate?.showBookRoomDetailsVC(meetingRoomId: selectedMeetingRoom!)
            }else{
                print("book button tag is book meetingroom",self.tag)

                backActionDelegate?.showBookMeetingRoomsVC()
            }
        }else {
            backActionDelegate?.showLogInVC()
        }
    }
}
