//
//  BookingConfirmedDateTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/03/24.
//

import UIKit

class BookingConfirmedDateTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var datetextFieldView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        datetextFieldView.setCornerRadiusForView()
    }

   
    
}
