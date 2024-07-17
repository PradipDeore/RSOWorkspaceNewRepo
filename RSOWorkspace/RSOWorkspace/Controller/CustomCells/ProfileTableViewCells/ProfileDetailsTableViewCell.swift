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
    func setData(item: MyProfile){
        if let firstName = item.data.firstName{
            self.firstName =  firstName
        }
        if let lastName = item.data.lastName{
            self.lastName = lastName
        }
        if let desg = item.data.designation{
            self.designation = desg
        }
        self.lblName.text = firstName + " " + lastName
        self.lblCompanyName.text = item.data.companyName
        self.lblEmail.text = item.data.email
        self.lblDesignation.text = item.data.designation
        self.lblPhoneNo.text = item.data.phone
        
    }
    @IBAction func btnEditAction(_ sender: Any) {
        
       // delegate?.sendDetails(fname: firstName, lname: lastName, designation: designation)
       
        delegate?.sendDetails()
    }
}
