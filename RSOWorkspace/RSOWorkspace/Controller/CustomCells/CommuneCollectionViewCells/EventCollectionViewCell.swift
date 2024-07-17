//
//  EventCollectionViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 20/03/24.
//

import UIKit
import Kingfisher

protocol ButtonRSVPTappedDelegate:AnyObject {
    func btnRSVPTappedAction()
}

class EventCollectionViewCell: UICollectionViewCell {
    
    weak var delegateButtonRSVP : ButtonRSVPTappedDelegate?
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnGuestCount: RSOButton!
    @IBOutlet weak var btnRSVP: UIButton!
    var cornerRadius: CGFloat = 10.0
    @IBOutlet weak var lblDateNo: UILabel!
    @IBOutlet weak var lblDateMonth: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblRoomName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblRoomNo: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnGuestCount.backgroundColor = .E_3_E_3_E_3
        btnGuestCount.layer.cornerRadius = 0.5 * btnGuestCount.bounds.size.width
        btnGuestCount.clipsToBounds = true
        
        self.btnRSVP.layer.cornerRadius = btnRSVP.bounds.height / 2
        customizeCell()
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
    
    func setData(item : EventsData){
        self.lblCompanyName.text = item.organizedBy
        self.lblDescription.text = item.description
        self.lblTitle.text = item.name
        if let day = item.onetimeDate?.day(), let monthName = item.onetimeDate{
            self.lblDateNo.text = "\(day)"
            self.lblDateMonth.text = "\(monthName)"
        }
        
        let imageUrl = item.image
        if ((imageUrl?.isEmpty) == nil){
            let url = URL(string: imageBasePath + (imageUrl ?? ""))
            self.imgEvent.kf.setImage(with: url)
        }
    }
    
    @IBAction func btnRSVPTappedAction(_ sender: Any) {
            delegateButtonRSVP?.btnRSVPTappedAction()
        
    }
}
