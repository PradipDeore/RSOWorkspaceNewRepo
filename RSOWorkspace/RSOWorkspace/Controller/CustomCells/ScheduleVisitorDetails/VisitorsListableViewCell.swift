//
//  VisitorsListableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/04/24.
//

import UIKit

class VisitorsListableViewCell: UITableViewCell {

    @IBOutlet weak var visitorsEmailView: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        visitorsEmailView.setCornerRadiusForView()
    }

    
}
