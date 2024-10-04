//
//  MembershipPlanTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/04/24.
//

import UIKit
import Kingfisher

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
    @IBOutlet weak var lblPlanLength: UILabel!
    @IBOutlet weak var lblPlanType: UILabel!
    @IBOutlet weak var lblMonthlyAccessibleDays: UILabel!
    @IBOutlet weak var lblMonthlyCost: UILabel!
    
    @IBOutlet weak var imgQRCode: UIImageView!
    var profileDetails: MyProfile?
    
    @IBOutlet weak var titleLabelPlanLength: UILabel!
    
    @IBOutlet weak var titleLabelPlanType: UILabel!
    
    @IBOutlet weak var titleLableMonthlyAccessibleDays: UILabel!
    
    @IBOutlet weak var titleLabelMonthlyCost: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
    }
    func setupUI(){
        if UserHelper.shared.isGuest(){
            self.btnRenewPlan.isHidden = true
            self.btnBuyMemberShip.isHidden = false
            
        }else{
            self.btnBuyMemberShip.isHidden = true
            self.lblMembershipPlan.isHidden = true
            self.btnRenewPlan.isHidden = false
        }
        
        self.btnRenewPlan.setCornerRadiusToButton2()
        self.btnBuyMemberShip.setCornerRadiusToButton2()
        
    }
    func setData(item: MyProfile){
        self.profileDetails = item
        if item.data.membershipName != nil{
            
            self.lblPlanType.text = "\(item.data.planType ?? "")"
            self.titleLabelPlanType.isHidden = false
            self.titleLabelPlanLength.isHidden = false
            self.titleLabelMonthlyCost.isHidden = false
            self.titleLableMonthlyAccessibleDays.isHidden = false
            self.lblPlanLength.text = "\(item.data.planLength ?? "") Months"
            self.lblMonthlyAccessibleDays.text = item.data.monthlyAccessibleDays
            self.lblMonthlyCost.text = "AED \(item.data.monthlyCost ?? "")"
            self.lblMembershipPlan.text = item.data.membershipName
            
            self.btnRenewPlan.isHidden = false
            self.btnBuyMemberShip.isHidden = true
        }else{
            self.lblMembershipPlan.text = "No Active Membership"
            self.lblPlanType.isHidden = true
            self.lblPlanLength.isHidden = true
            self.lblMonthlyAccessibleDays.isHidden = true
            self.lblMonthlyCost.isHidden = true
            self.titleLabelPlanType.isHidden = true
            self.titleLabelPlanLength.isHidden = true
            self.titleLabelMonthlyCost.isHidden = true
            self.titleLableMonthlyAccessibleDays.isHidden = true
            
            self.btnBuyMemberShip.isHidden = false
            self.btnRenewPlan.isHidden = true
        }
        
        
        // Load the QR code image from the URL
        if let qrCodeUrlString = item.data.qrCodeUrl, let qrCodeUrl = URL(string: qrCodeUrlString) {
            self.imgQRCode.kf.setImage(with: qrCodeUrl)
        } else {
            // Handle case where QR code URL is not available or valid
            self.imgQRCode.image = UIImage(named: "dmmy")
        }
        
    }
    
    @IBAction func btnBuyMembershipAction(_ sender: Any) {
        delegate?.navigateToDisplayMembershipPlans()
        
    }
    @IBAction func btnRenewMemberShipPlan(_ sender: Any) {
        delegate?.navigateToDisplayMembershipPlans()
        
    }
}
