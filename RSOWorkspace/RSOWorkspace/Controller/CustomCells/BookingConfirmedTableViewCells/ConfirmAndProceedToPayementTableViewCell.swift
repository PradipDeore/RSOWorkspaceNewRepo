//
//  ConfirmAndProceedToPayementTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/03/24.
//

import UIKit
protocol ConfirmAndProceedToPayementTableViewCellDelegate:AnyObject{
    func btnConfirmAndProceedTappedAction()
}
class ConfirmAndProceedToPayementTableViewCell: UITableViewCell {

    weak var delegate: ConfirmAndProceedToPayementTableViewCellDelegate?
    @IBOutlet weak var btnConfirmAndProceed: RSOButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnConfirmAndProceed.setCornerRadiusToButton()
        btnConfirmAndProceed.backgroundColor = .E_2_F_0_D_9
        btnConfirmAndProceed.setTitleColor(.black, for: .normal)
    }

    @IBAction func btnConfirmAndProceedTappedAction(_ sender: Any) {
        delegate?.btnConfirmAndProceedTappedAction()
    }
}
