//
//  PlanPriceTableViewCell.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 25/07/24.
//

import UIKit

class PlanPriceTableViewCell: UITableViewCell {
  @IBOutlet weak var radioIconImageView: UIImageView!
  @IBOutlet weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      setRadioImage(selcted: false)
    }
  
  func setRadioImage(selcted isSelected: Bool) {
    if isSelected {
      self.radioIconImageView.image = UIImage(named: "radio-button-selected")
    } else {
      self.radioIconImageView.image = UIImage(named: "radio-button-unselected")
    }
  }
  
  func setTextMessage(attributedMsg: NSAttributedString) {
    messageLabel.attributedText = attributedMsg
  }
}
