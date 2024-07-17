//
//  OtherBookingsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 27/02/24.
//

import UIKit

class OtherBookingsTableViewCell: UITableViewCell {

    @IBOutlet weak var btnBookLocker: RSOButton!
    @IBOutlet weak var btnBookBike: RSOButton!
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        customizeCell()
      
    }
    func customizeCell(){
        self.btnBookLocker.layer.cornerRadius = btnBookLocker.bounds.height / 2
        self.btnBookBike.layer.cornerRadius = btnBookBike.bounds.height / 2
        
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        
        self.addShadow()
    }
   
    
}
