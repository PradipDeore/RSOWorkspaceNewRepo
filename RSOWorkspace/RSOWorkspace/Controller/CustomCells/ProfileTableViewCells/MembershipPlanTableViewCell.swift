//
//  MembershipPlanTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/04/24.
//

import UIKit
protocol MembershipPlanDelegate:AnyObject{
    func navigateToDisplayMembershipPlans()
}

class MembershipPlanTableViewCell: UITableViewCell {

    weak var delegate:MembershipPlanDelegate?
    var cornerRadius: CGFloat = 10.0
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var btnBuyMemberShip: RSOButton!
    @IBOutlet weak var btnRenewPlan: RSOButton!
    @IBOutlet weak var lblMembershipPlan: UILabel!
    @IBOutlet weak var lblMemberShipDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
    }
    func setupUI(){
        if UserHelper.shared.isGuest(){
            self.btnRenewPlan.isHidden = true
            self.btnBuyMemberShip.isHidden = false
            self.lblMembershipPlan.isHidden = true
            self.lblMemberShipDesc.text = "No Active Membership"
        }else{
            self.btnBuyMemberShip.isHidden = true
            self.lblMembershipPlan.isHidden = true
            self.lblMemberShipDesc.isHidden = true
            self.btnRenewPlan.isHidden = false
        }
        
        self.btnRenewPlan.setCornerRadiusToButton2()
        self.btnBuyMemberShip.setCornerRadiusToButton2()
        
    }
    func setData(item: MyProfile){
            //self.lblMembershipPlan.text = item.data.membershipName
           // self.lblMemberShipDesc.text = item.data.desc
    }
    
    @IBAction func btnBuyMembershipAction(_ sender: Any) {
        delegate?.navigateToDisplayMembershipPlans()
        
    }
    @IBAction func btnRenewMemberShipPlan(_ sender: Any) {
        delegate?.navigateToDisplayMembershipPlans()
        
    }
}
