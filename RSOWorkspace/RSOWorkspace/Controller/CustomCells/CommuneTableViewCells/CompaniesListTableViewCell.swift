//
//  CompaniesListTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/03/24.
//

import UIKit
protocol ButtonBrowseMambersDelegate:AnyObject{
    func btnBrowseMembersTappedAction(index:Int)
}

class CompaniesListTableViewCell: UITableViewCell {

    weak var delegate : ButtonBrowseMambersDelegate?
    @IBOutlet weak var btnCall: RSOButton!
    @IBOutlet weak var btnBrowseMembers: RSOButton!
   
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblCompaniesSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnCall.layer.cornerRadius = 9.0
        self.btnBrowseMembers.layer.cornerRadius = btnBrowseMembers.bounds.height / 2
    }

    @IBAction func btnCallTappedAction(_ sender: Any) {
//        guard let phoneNumber = lblMemberPhone.text, !phoneNumber.isEmpty else {
//            print("Phone number is not available")
//            return
//        }
//        // Use the utility method to make a phone call
//        PhoneCallUtility.makePhoneCall(to: phoneNumber)
    }
    
    @IBAction func btnBrowseMembersTappedActDelegate(_ sender: Any) {
        
        delegate?.btnBrowseMembersTappedAction(index: self.tag)
    }
    func setData(item : Company){
        self.lblCompanyName.text = item.name
        self.lblCompaniesSubtitle.text = item.description
    }
    
}
