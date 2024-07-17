//
//  VisitorsDateTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/04/24.
//

import UIKit

class VisitorsDateTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var txtDate: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.setCornerRadiusForView()
    }

   
    
}
