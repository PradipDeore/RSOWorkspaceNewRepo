//
//  NoOfSeatsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 27/07/24.
//

import UIKit

class NoOfSeatsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNoOfSeats: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(with noOfSeats: Int) {
           lblNoOfSeats.text = "\(noOfSeats)"
       }
    
}
