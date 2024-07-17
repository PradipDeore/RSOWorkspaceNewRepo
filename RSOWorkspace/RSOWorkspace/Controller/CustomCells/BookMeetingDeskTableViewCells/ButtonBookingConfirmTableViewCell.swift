//
//  ButtonBookingConfirmTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/03/24.
//

import UIKit
protocol ButtonBookingConfirmTableViewCellDelegate:AnyObject{
    func btnConfirmTappedAction()
}

class ButtonBookingConfirmTableViewCell: UITableViewCell {
   
    weak var delegate: ButtonBookingConfirmTableViewCellDelegate?
    
    @IBOutlet weak var btnConfirm: RSOButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnConfirm.layer.cornerRadius = btnConfirm.bounds.height / 2
    }

    @IBAction func btnConfirmTappedAction(_ sender: RSOButton) {
        delegate?.btnConfirmTappedAction()
    }
}
