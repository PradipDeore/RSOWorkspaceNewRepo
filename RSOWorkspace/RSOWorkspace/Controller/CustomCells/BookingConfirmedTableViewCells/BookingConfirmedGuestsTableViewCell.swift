//
//  BookingConfirmedGuestsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/03/24.
//

import UIKit

class BookingConfirmedGuestsTableViewCell: UITableViewCell{
    
    @IBOutlet weak var guestEmailView: UIView!
    @IBOutlet weak var lblEmail: UILabel!

        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            guestEmailView.setCornerRadiusForView()
        }

}
