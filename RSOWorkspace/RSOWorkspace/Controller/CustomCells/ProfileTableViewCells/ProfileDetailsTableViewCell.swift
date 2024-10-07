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
        // Check if firstName and lastName are available, otherwise set blank text
           let firstName = myProfileDetails.firstName?.isEmpty == false ? myProfileDetails.firstName! : ""
           let lastName = myProfileDetails.lastName?.isEmpty == false ? myProfileDetails.lastName! : ""
           self.lblName.text = "\(firstName) \(lastName)"
           
           // Check for company name, email, designation, and phone number availability
           self.lblCompanyName.text = myProfileDetails.companyName?.isEmpty == false ? myProfileDetails.companyName : ""
           self.lblEmail.text = myProfileDetails.email?.isEmpty == false ? myProfileDetails.email : ""
           self.lblDesignation.text = myProfileDetails.designation?.isEmpty == false ? myProfileDetails.designation : ""
           self.lblPhoneNo.text = myProfileDetails.phone?.isEmpty == false ? myProfileDetails.phone : ""
        
      
        if let photoURLString = myProfileDetails.photo, !photoURLString.isEmpty {
            let url = URL(string: imageBasePath + photoURLString)
            self.imgProfile.kf.setImage(with: url)
        }
    }
   
  
  @IBAction func btnEditAction(_ sender: Any) {
    delegate?.sendDetails()
  }
}
