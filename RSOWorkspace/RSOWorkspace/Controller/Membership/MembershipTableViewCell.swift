//
//  MembershipTableViewCell.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 01/08/24.
//

import UIKit

import UIKit

class MembershipTableViewCell: UITableViewCell {

    // Container view to hold MembershipViewController's view
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with viewController: UIViewController) {
        // Remove any existing subviews
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        // Add the MembershipViewController's view
        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        
        // Ensure view controller's view resizes correctly
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
