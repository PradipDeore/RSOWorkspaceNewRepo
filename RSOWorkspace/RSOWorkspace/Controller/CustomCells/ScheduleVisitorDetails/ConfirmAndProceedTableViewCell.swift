//
//  ConfirmAndProceedTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 10/04/24.
//

import UIKit
protocol ConfirmAndProceedTableViewCellDelegate:AnyObject{
    func navigateToMyvisitors()
}

class  ConfirmAndProceedTableViewCell: UITableViewCell {

    weak var delegate:ConfirmAndProceedTableViewCellDelegate?
    @IBOutlet weak var btnConfirmAndProceed: RSOButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnConfirmAndProceed.setCornerRadiusToButton()
        btnConfirmAndProceed.backgroundColor = ._768_D_70
    }

    @IBAction func btnConfirmAndProceedAction(_ sender: RSOButton) {
        delegate?.navigateToMyvisitors()
    }
    
    
}
