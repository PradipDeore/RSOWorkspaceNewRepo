//
//  OnDemandServicesTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/03/24.
//

import UIKit

class OnDemandServicesTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customizeCell()
    }
    func customizeCell(){
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        
        self.containerView.addShadow()
    }
    
}
