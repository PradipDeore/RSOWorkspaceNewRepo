//
//  SelectDeskCollectionViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 12/04/24.
//

import UIKit

class SelectDeskCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var deskNoView: UIView!
    @IBOutlet weak var lblDeskNo: UILabel!
    var cornerRadius: CGFloat = 10.0

    override func awakeFromNib() {
        super.awakeFromNib()
        //customizeCell()
        deskNoView.setCornerRadiusForView()
    }
    func customizeCell(){
        self.deskNoView.layer.cornerRadius = cornerRadius
        self.deskNoView.layer.masksToBounds = true
        
        let shadowColor = UIColor.black.withAlphaComponent(0.5)
        self.deskNoView.layer.shadowColor = shadowColor.cgColor
        self.deskNoView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.deskNoView.layer.shadowRadius = 10.0
        self.deskNoView.layer.shadowOpacity = 19.0
        self.deskNoView.layer.masksToBounds = false
        self.deskNoView.layer.shadowPath = UIBezierPath(roundedRect:  CGRect(x: 0, y: self.deskNoView.bounds.height - 4, width: self.deskNoView.bounds.width, height: 4), cornerRadius: self.deskNoView.layer.cornerRadius).cgPath
    }
}
