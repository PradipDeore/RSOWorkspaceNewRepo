//
//  ConfirmSelectedDeskTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/04/24.
//

import UIKit

class ConfirmSelectedDeskTableViewCell: UITableViewCell {

    var cornerRadius: CGFloat = 10.0
    @IBOutlet weak var deskNoView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       customizeCell()
    }
    func customizeCell(){
        self.deskNoView.layer.cornerRadius = cornerRadius
        self.deskNoView.layer.masksToBounds = true
      
        self.addShadow()
    }
    
}
