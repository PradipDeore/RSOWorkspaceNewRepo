//
//  ReasonForVistirTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/04/24.
//

import UIKit

class ReasonForVisitTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var txtReasonForVisit: RSOTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.setCornerRadiusForView()
        txtReasonForVisit.borderStyle = .none
        txtReasonForVisit.customBorderWidth = 0.0
    }

    
    
}
