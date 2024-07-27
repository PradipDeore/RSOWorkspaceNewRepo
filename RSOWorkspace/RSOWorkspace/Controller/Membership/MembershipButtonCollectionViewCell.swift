//
//  MembershipButtonCollectionViewCell.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 25/07/24.
//

import UIKit

class MembershipButtonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var btnType: UIButton!
    @IBOutlet weak var sideView1: UIView!
    @IBOutlet weak var sideView2: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  func selectButton(selcted isSelected: Bool) {
    if isSelected {
      let color =  UIColor(named: "405629")
      self.btnType.setTitleColor(.white, for: .normal)
      self.btnType.backgroundColor = color
      self.sideView1.backgroundColor = color
      self.sideView2.backgroundColor = color
    } else {
      let color =  UIColor(named: "C9C9C9")
      self.btnType.setTitleColor(.black, for: .normal)
      self.btnType.backgroundColor = color
      self.sideView1.backgroundColor = color
      self.sideView2.backgroundColor = color
    }
  }
}
