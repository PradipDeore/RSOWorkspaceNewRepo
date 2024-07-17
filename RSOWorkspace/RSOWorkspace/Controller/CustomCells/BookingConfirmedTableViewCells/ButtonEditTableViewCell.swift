//
//  ButtonEditTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/03/24.
//

import UIKit
protocol ButtonEditTableViewCellDelegate:AnyObject{
    func navigateToBookingDetails()
}
class ButtonEditTableViewCell: UITableViewCell {

    weak var delegate: ButtonEditTableViewCellDelegate?
    @IBOutlet weak var btnEdit: RSOButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnEdit.setCornerRadiusToButton()
    }

    @IBAction func btnEditTappedAction(_ sender: Any) {
        delegate?.navigateToBookingDetails()
    }
}
