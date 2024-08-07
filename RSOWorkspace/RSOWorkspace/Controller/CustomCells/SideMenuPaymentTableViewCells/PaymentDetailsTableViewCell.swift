//
//  PaymentDetailsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/07/24.
//

import UIKit

class PaymentDetailsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblBookingItemPrice: UILabel!
    @IBOutlet weak var lblBookingItemName: UILabel!
    @IBOutlet weak var lblBookingItemDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setData(item: GetAllBookings) {
            lblBookingItemDate.text = item.date
            lblBookingItemName.text = item.name
            
            // Check if the booking is for an office or a room
            if let officePrice = item.price {
                // Display office price
                lblBookingItemPrice.text = officePrice
            } else if let roomPrice = item.roomPrice {
                // Display room price
                lblBookingItemPrice.text = roomPrice
            } else {
                // Handle the case where price is not available
                lblBookingItemPrice.text = "N/A"
            }
        }
}
    
