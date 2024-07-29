//
//  AgreementCollectionViewCell.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 27/07/24.
//

import UIKit

class AgreementCollectionViewCell: UICollectionViewCell {

  @IBOutlet var durationLabel: UILabel!
  @IBOutlet var priceLabel: UILabel!
  @IBOutlet var typeNameLabel: UILabel!
  @IBOutlet var containerView: UIView!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    self.selectCell(isSelected: false)
    }
  func setData(planPrice:PlanPrice) {
    self.durationLabel.text = "per month"
    self.priceLabel.text = planPrice.price
    self.typeNameLabel.text = "\(planPrice.length ?? 0) month"
  }
  
  func selectCell(isSelected: Bool) {
    if isSelected {
      self.containerView.backgroundColor = UIColor(named: "E3E3E3")
      self.containerView.layer.borderColor = UIColor.gray.cgColor
      self.containerView.layer.borderWidth = 1.0
    } else {
      self.containerView.backgroundColor = .white
      self.containerView.layer.borderColor = UIColor.lightGray.cgColor
      self.containerView.layer.borderWidth = 0.5
    }
  }
}
