//
//  MyBookingCloseTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/02/24.
//

import UIKit

class MyBookingCloseTableViewCell: UITableViewCell {

    @IBOutlet weak var btnBooking: UIButton!
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0

    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
    }
    func customizeCell(){
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        
        self.addShadow()
    }
   
}
