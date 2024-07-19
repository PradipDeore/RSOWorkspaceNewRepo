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
  func setData(){
    let user = UserHelper.shared
    if let firstName = user.getUserFirstName() {
      self.firstName =  firstName
    }
    if let lastName = user.getUserLastName() {
      self.lastName = lastName
    }
    if let desg = user.getUserDesignation() {
      self.designation = desg
    }
    self.lblName.text = firstName + " " + lastName
    self.lblCompanyName.text = user.getUserCompanyID()
    self.lblEmail.text = user.getUserEmail()
    self.lblDesignation.text = self.designation
    self.lblPhoneNo.text = ""
  }
  
  @IBAction func btnEditAction(_ sender: Any) {
    delegate?.sendDetails()
  }
}
