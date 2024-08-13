//
//  InviteVisitorsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/04/24.
//

import UIKit

protocol InviteVisitorsTableViewCellDelegate:AnyObject{
    func btnDeleteVisitors(buttonTag:Int)
 
}
class InviteVisitorsTableViewCell: UITableViewCell {

    weak var delegate : InviteVisitorsTableViewCellDelegate?
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblVisitorEmail: UILabel!
    @IBOutlet weak var visitorEmailView: UIView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        //customizeCell()
/*
        visitorEmailView.setCornerRadiusForView()
        // Create a UIBezierPath for the rounded corners
        let maskPath = UIBezierPath(roundedRect: containerView.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))

        // Create a CAShapeLayer with the path
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath

        // Apply the mask to the containerView's layer
        containerView.layer.mask = maskLayer
 */
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
   
    
    @IBAction func btndeleTappedAction(_ sender: UIButton) {
        delegate?.btnDeleteVisitors(buttonTag: sender.tag)
    }
    func resetTextFields(){
        
    }
}
