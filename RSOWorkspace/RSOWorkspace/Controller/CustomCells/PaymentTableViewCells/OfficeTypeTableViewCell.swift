//
//  OfficeTypeTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 29/07/24.
//

import UIKit

class OfficeTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOfficeName: UILabel!
    @IBOutlet weak var lblNoOfSeats: UILabel!
    @IBOutlet weak var lbltotalPrice: UILabel!
   
    @IBOutlet weak var lblOfficeNameWithPrice: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
}
