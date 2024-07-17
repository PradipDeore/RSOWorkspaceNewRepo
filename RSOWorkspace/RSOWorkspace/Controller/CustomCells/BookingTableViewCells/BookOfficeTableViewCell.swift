//
//  BookOfficeTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 27/02/24.
//

import UIKit

class BookOfficeTableViewCell: UITableViewCell {

    @IBOutlet weak var btnShortTermBooking: RSOButton!
    @IBOutlet weak var btnLongTermBooking: RSOButton!
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0

    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
    }
    func customizeCell(){
        self.btnShortTermBooking.layer.cornerRadius = btnShortTermBooking.bounds.height / 2
        self.btnLongTermBooking.layer.cornerRadius = btnLongTermBooking.bounds.height / 2
       
        
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        
        self.addShadow()
        
       
       
        
    }
    
    
}
