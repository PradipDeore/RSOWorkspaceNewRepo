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
            lblBookingItemName.text = item.name
            
            if item.bookingType == "office" {
                lblBookingItemPrice.text = "\(item.totalPrice ?? "0.0")"
                lblBookingItemDate.text = item.date
            } else if item.bookingType == "desk" {
                lblBookingItemPrice.text = "\(item.totalPrice ?? "0.0")"
                lblBookingItemDate.text = item.date
            } else if item.bookingType == "meeting" {
                lblBookingItemPrice.text = "\(item.totalPrice ?? "0.0")"
                lblBookingItemDate.text = item.date
            } else {
                lblBookingItemPrice.text = "Unknown Booking Type"
            }
        }
}
    
