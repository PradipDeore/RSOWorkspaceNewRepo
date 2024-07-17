//
//  ReasonForVistirTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/04/24.
//

import UIKit

class ReasonForVisitTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var txtReasonForVisit: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.setCornerRadiusForView()
    }

    
    
}
