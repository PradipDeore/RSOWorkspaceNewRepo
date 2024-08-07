//
//  MembersSearchListTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/03/24.
//

import UIKit

class FindMembersSearchListTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    @IBOutlet weak var lblMemberName: UILabel!
    
    @IBOutlet weak var lblFirstName: UILabel!
    
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblMemberEmail: UILabel!
    @IBOutlet weak var lblMemberPhone: UILabel!
    @IBOutlet weak var btnCall: RSOButton!
    var memberCompany:String?
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
    }
    func customizeCell(){
        self.btnCall.layer.cornerRadius = 9.0

        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        
        let shadowColor = UIColor.black.withAlphaComponent(0.5)
        self.containerView.layer.shadowColor = shadowColor.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.containerView.layer.shadowRadius = 10.0
        self.containerView.layer.shadowOpacity = 19.0
        self.containerView.layer.masksToBounds = false
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect:  CGRect(x: 0, y: self.containerView.bounds.height - 4, width: self.containerView.bounds.width, height: 4), cornerRadius: self.containerView.layer.cornerRadius).cgPath
    }
    
    func setData(item : Member, memberCompany:String){
        self.lblFirstName.text = item.firstName
        self.lblLastName.text = item.lastName
        self.lblMemberEmail.text = item.email
        self.lblMemberPhone.text = item.phone
        self.lblCompanyName.text = memberCompany
    }
//    func setData(company: Company, members: [Member]) {
//        // Set company name
//        self.lblCompanyName.text = company.name
//        
//        // Initialize variables to store member information
//        var firstNames = ""
//        var lastNames = ""
//        var emails = ""
//        var phones = ""
//        
//        // Iterate over each member
//        for (index, member) in members.enumerated() {
//            // If there are multiple members, create a new line for each member's information
//            if index > 0 {
//                firstNames += "\n"
//                lastNames += "\n"
//                emails += "\n"
//                phones += "\n"
//            }
//            
//            // Set member information
//            if let firstName = member.firstName {
//                firstNames += firstName
//            }
//            if let lastName = member.lastName {
//                lastNames += lastName
//            }
//            if let email = member.email {
//                emails += email
//            }
//            if let phone = member.phone {
//                phones += phone
//            }
//        }
//        
//        // Set member information to labels
//        self.lblFirstName.text = firstNames
//        self.lblLastName.text = lastNames
//        self.lblMemberEmail.text = emails
//        self.lblMemberPhone.text = phones
//    }

    @IBAction func btnCallTappedAction(_ sender: Any) {
        guard let phoneNumber = lblMemberPhone.text, !phoneNumber.isEmpty else {
            print("Phone number is not available")
            return
        }
        // Use the utility method to make a phone call
        PhoneCallUtility.makePhoneCall(phoneNumber: phoneNumber)
    }
    
}
