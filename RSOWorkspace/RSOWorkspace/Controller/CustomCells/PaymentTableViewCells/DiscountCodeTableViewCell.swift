//
//  DiscountCodeTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 06/03/24.
//

import UIKit

class DiscountCodeTableViewCell: UITableViewCell {

    @IBOutlet weak var txtDiscount: RSOTextField!
    @IBOutlet weak var btnApply: RSOButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtDiscount.placeholderText = "  Have a Disount Code?"
        txtDiscount.placeholderFont = RSOFont.inter(size: 12, type: .Medium)
        btnApply.setCornerRadiusToButton()
        txtDiscount.placeholderColor = ._454545
    }

   
    
}
