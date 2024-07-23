//
//  floorPlanCollectionViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/07/24.
//

import UIKit

class floorPlanCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var seatingConfigImage: UIImageView!
    @IBOutlet weak var configImageview: UIView!
    var cornerRadius: CGFloat = 10.0
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

}
