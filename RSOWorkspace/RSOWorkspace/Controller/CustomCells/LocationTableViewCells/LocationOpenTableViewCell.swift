//
//  LocationOpenTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/04/24.
//

import UIKit

class LocationOpenTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnLocationArrow: UIButton!
    var cornerRadius: CGFloat = 10.0
    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblAddress1: UILabel!
   
    @IBOutlet weak var lblGeoLocation: UILabel!
    @IBOutlet weak var btnCall: RSOButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
        btnCall.setCornerRadiusToButton()
    }

    func customizeCell(){
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
    @IBAction func btnLocationArrowTappedAction(_ sender: Any) {
        
    }
    
    @IBAction func btnCallTappedAction(_ sender: Any) {
        if let phoneNumber = lblPhoneNumber.text {
                    PhoneCallUtility.makePhoneCall(phoneNumber: phoneNumber)
               
        }
    }
    
    
}
