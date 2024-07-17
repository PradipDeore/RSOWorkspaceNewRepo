//
//  MembershipPlanTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/04/24.
//

import UIKit

class MembershipPlanTableViewCell: UITableViewCell {

    var cornerRadius: CGFloat = 10.0
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var btnRenewPlan: RSOButton!
    @IBOutlet weak var lblMembershipPlan: UILabel!
    @IBOutlet weak var lblMemberShipDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    
    }
    func setupUI(){
       
        self.btnRenewPlan.setCornerRadiusToButton2() 
        
    }
    func setData(item: MyProfile){
        self.lblMembershipPlan.text = item.data.membershipName
        self.lblMemberShipDesc.text = item.data.desc
    }
}
