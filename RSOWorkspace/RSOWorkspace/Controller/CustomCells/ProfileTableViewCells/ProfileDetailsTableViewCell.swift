//
//  ProfileDetailsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/04/24.
//

import UIKit

protocol editProfileDelegate:AnyObject{
  //func sendDetails(fname:String,lname:String,designation:String)
  func sendDetails()
}
class ProfileDetailsTableViewCell: UITableViewCell {
  
  weak var delegate:editProfileDelegate?
  @IBOutlet weak var imgProfile: UIImageView!
  @IBOutlet weak var lblCompanyName: UILabel!
  @IBOutlet weak var lblPhoneNo: UILabel!
  @IBOutlet weak var lblEmail: UILabel!
  @IBOutlet weak var lblName: UILabel!
  @IBOutlet weak var lblDesignation: UILabel!
  var cornerRadius: CGFloat = 10.0
  @IBOutlet weak var containerView: ShadowedView!
  @IBOutlet weak var btnEdit: RSOButton!
  var firstName = ""
  var lastName = ""
  var designation = ""
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  func setupUI(){
    self.imgProfile.setRounded()
    self.btnEdit.setCornerRadiusToButton2()
    
  }
//  func setData(){
//    let user = UserHelper.shared
//    if let desg = user.getUserDesignation() {
//      self.designation = desg
//    }
//    self.lblName.text = user.getFullname()
//    self.lblCompanyName.text = user.getUserCompanyID()
//    self.lblEmail.text = user.getUserEmail()
//    self.lblDesignation.text = self.designation
//    self.lblPhoneNo.text = ""
//  }
    func setData(myProfileDetails : ProfileData){
        self.lblName.text = "\(myProfileDetails.firstName ?? "") \(myProfileDetails.lastName ?? "")"
        self.lblCompanyName.text = myProfileDetails.companyName
        self.lblEmail.text = myProfileDetails.email
        self.lblDesignation.text = myProfileDetails.designation
        self.lblPhoneNo.text = myProfileDetails.phone
        
        if let photoURLString = myProfileDetails.photo, !photoURLString.isEmpty {
            let url = URL(string: imageBasePath + photoURLString)
            self.imgProfile.kf.setImage(with: url)
        }
    }
    func setDataExplorer(myProfileDetails : ProfileData){
        self.lblName.text = ""
        self.lblCompanyName.text = ""
        self.lblEmail.text = ""
        self.lblDesignation.text = ""
        self.lblPhoneNo.text = ""
        
//        if let photoURLString = myProfileDetails.photo, !photoURLString.isEmpty {
//            let url = URL(string: imageBasePath + photoURLString)
//            self.imgProfile.kf.setImage(with: url)
//        }
    }
  
  @IBAction func btnEditAction(_ sender: Any) {
    delegate?.sendDetails()
  }
}
