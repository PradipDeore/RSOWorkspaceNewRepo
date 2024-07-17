//
//  EditButtonTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 10/04/24.
//

import UIKit
protocol EditButtonTableViewCellDelegate:AnyObject{
    func navigateScheduleVisitors()
}
class EditButtonTableViewCell: UITableViewCell {

    weak var delegate: EditButtonTableViewCellDelegate?
    @IBOutlet weak var btnEdit: RSOButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnEdit.setCornerRadiusToButton()
    }

    @IBAction func btnEditTappedAction(_ sender: Any) {
        delegate?.navigateScheduleVisitors()
    }
}
