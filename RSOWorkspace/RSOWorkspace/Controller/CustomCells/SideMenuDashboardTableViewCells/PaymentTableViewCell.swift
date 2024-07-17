//
//  PaymentTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/04/24.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    var cornerRadius: CGFloat = 10.0
    @IBOutlet weak var lblMonthName: UILabel!
    @IBOutlet weak var lblPaymentAmount: UILabel!
    @IBOutlet weak var txtMothName: UITextField!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        monthView.setCornerRadiusForView()
        txtMothName.setUpTextFieldView(rightImageName:"arrowdown")
        customizeCell()
    }
    func customizeCell(){
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        
        let shadowColor = UIColor.black.withAlphaComponent(0.5)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 19.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:  CGRect(x: 0, y: self.bounds.height - 4, width: self.bounds.width, height: 4), cornerRadius: self.containerView.layer.cornerRadius).cgPath
    }
    @IBAction func btnMonthDropdownTappedAction(_ sender: Any) {
    }
    
    
}
