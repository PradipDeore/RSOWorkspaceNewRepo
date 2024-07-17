//
//  VisitorsTimeTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/04/24.
//

import UIKit

class VisitorsTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var txtTime: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.setCornerRadiusForView()
        txtTime.setUpTextFieldView(leftImageName:"clock")
    }

    
}
