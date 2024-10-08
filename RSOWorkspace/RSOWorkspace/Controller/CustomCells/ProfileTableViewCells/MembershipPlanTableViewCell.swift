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
        if UserHelper.shared.isGuest() || UserHelper.shared.isSocialLoginUser(){
            self.btnRenewPlan.isHidden = true
            self.btnBuyMemberShip.isHidden = false
            self.lblMembershipPlan.isHidden = false
            
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
        if item.data.membershipName != nil {
            
            self.titleLabelPlanType.isHidden = false
            self.titleLabelPlanLength.isHidden = false
            self.titleLabelMonthlyCost.isHidden = false
            self.titleLableMonthlyAccessibleDays.isHidden = false
            self.lblPlanLength.text = "\(item.data.planLength ?? "") Months"
            self.lblPlanType.text = "\(item.data.planType ?? "")"

            self.lblMonthlyAccessibleDays.text = item.data.monthlyAccessibleDays
            self.lblMonthlyCost.text = "AED \(item.data.monthlyCost ?? "")"
            self.lblMembershipPlan.text = item.data.membershipName
            
            self.btnRenewPlan.isHidden = false
            self.btnBuyMemberShip.isHidden = true
        
        }else{
            self.lblMembershipPlan.text = "no active membership"
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
       
      
        if let qrCodeUrlString = item.qrCodeUrl {
               print("QR Code URL: \(qrCodeUrlString)") // Check the URL being passed
               if let qrCodeUrl = URL(string: qrCodeUrlString) {
                   self.imgQRCode.kf.setImage(with: qrCodeUrl)
               }
           } else {
               print("QR Code URL is nil")
               self.imgQRCode.image = UIImage(named: "dummyQRCode")
           }
        
    }
    
   

    // Helper functions to show or hide the membership plan details
    func showPlanDetails() {
        self.titleLabelPlanType.isHidden = false
        self.titleLabelPlanLength.isHidden = false
        self.titleLabelMonthlyCost.isHidden = false
        self.titleLableMonthlyAccessibleDays.isHidden = false
        self.lblPlanLength.isHidden = false
        self.lblPlanType.isHidden = false
        self.lblMonthlyAccessibleDays.isHidden = false
        self.lblMonthlyCost.isHidden = false
    }

    func hidePlanDetails() {
        self.titleLabelPlanType.isHidden = true
        self.titleLabelPlanLength.isHidden = true
        self.titleLabelMonthlyCost.isHidden = true
        self.titleLableMonthlyAccessibleDays.isHidden = true
        self.lblPlanLength.isHidden = true
        self.lblPlanType.isHidden = true
        self.lblMonthlyAccessibleDays.isHidden = true
        self.lblMonthlyCost.isHidden = true
    }

    
    @IBAction func btnBuyMembershipAction(_ sender: Any) {
        delegate?.navigateToDisplayMembershipPlans()
        
    }
    @IBAction func btnRenewMemberShipPlan(_ sender: Any) {
        delegate?.navigateToDisplayMembershipPlans()
        
    }
       
}
