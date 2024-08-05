//
//  PaymentDateTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/07/24.
//

import UIKit

class PaymentDateTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCurrentMonthName: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(withTotalPrice totalPrice: Double, monthName: String) {
            lblTotalPrice.text = String(format: "%.2f", totalPrice)
            lblCurrentMonthName.text = monthName.uppercased()
        }
    
}
