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
    
    @IBOutlet weak var imgLocation: UIImageView!
    var cornerRadius: CGFloat = 10.0
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
    }
    func customizeCell(){
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        
        let shadowColor = UIColor.black.withAlphaComponent(0.2)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.layer.masksToBounds = false
        // Set shadow path to match the bottom area of the container
          self.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: self.bounds.height - 4, width: self.bounds.width, height: 4), cornerRadius: self.containerView.layer.cornerRadius).cgPath
      }
    
    func setData(item: MarketPlaceItem) {
        // Logo
        if let headerImg = item.headerImg, !headerImg.isEmpty {
            let url = URL(string: imageBasePath + headerImg)
            self.imgLogoImage.kf.setImage(with: url)
        }else{
            self.imgHeaderImage.image = UIImage(named: "NOImage")
        }
        
        // Headline
        self.lblHeadline.text = item.headline
        self.lblHeadline2.text = item.headline2
        self.lblSubtext.text = item.subtext
        // Image
        if let image = item.image, !image.isEmpty {
            let url = URL(string: imageBasePath + image)
            self.imgHeaderImage.kf.setImage(with: url)
        }
      
        if let location =  item.location, !location.isEmpty{
            self.lblLocation.text = location
            self.imgLocation.isHidden = false
        }else{
            self.lblLocation.text = ""
            self.imgLocation.isHidden = true
        }
    }
        
}
