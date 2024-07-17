//
//  CancelAndRequestButtonTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 07/03/24.
//

import UIKit

protocol CancelAndRequestButtonTableViewCellDelegate:AnyObject{
    func btnCancelTappedAction()
    func btnRequestTappedAction()
}

class CancelAndRequestButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var btnRequest: RSOButton!
    @IBOutlet weak var btnCancel: RSOButton!
    weak var delegate: CancelAndRequestButtonTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        btnCancel.setCornerRadiusToButton()
        btnRequest.setCornerRadiusToButton()
        btnRequest.backgroundColor = .E_2_F_0_D_9
        btnRequest.setTitleColor(.black, for: .normal)
    }
 
    @IBAction func btnCancelTappedAction(_ sender: Any) {
        delegate?.btnCancelTappedAction()
    }
    
    @IBAction func btnRequestTappedAction(_ sender: Any) {
        delegate?.btnRequestTappedAction()
    }
    
}
