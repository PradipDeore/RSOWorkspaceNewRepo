//
//  MarketPlaceCollectionViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/02/24.
//

import UIKit
import Kingfisher

class MarketPlaceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgHeaderImage: UIImageView!
    @IBOutlet weak var imgLogoImage: UIImageView!
    @IBOutlet weak var lblHeadline: UILabel!
    @IBOutlet weak var lblHeadline2: UILabel!
    @IBOutlet weak var lblSubtext: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    var cornerRadius: CGFloat = 10.0
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
    }
    func customizeCell(){
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        
        let shadowColor = UIColor.black.withAlphaComponent(0.5)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 19.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:  CGRect(x: 0, y: self.bounds.height - 4, width: self.bounds.width, height: 4), cornerRadius: self.containerView.layer.cornerRadius).cgPath
    }
    func setData(item : MarketPlaceItem){
        //logo
        if !item.headerImg.isEmpty {
            let url = URL(string: imageBasePath + item.headerImg)
            self.imgLogoImage.kf.setImage(with: url)
        }
        self.lblHeadline.text = item.headline
        self.lblHeadline2.text = item.headline2
        self.lblSubtext.text = item.subtext
        self.lblLocation.text = item.location
        // image
        if !item.image.isEmpty {
            let url = URL(string: imageBasePath + item.image)
            self.imgHeaderImage.kf.setImage(with: url)
        }
        
    }
}
