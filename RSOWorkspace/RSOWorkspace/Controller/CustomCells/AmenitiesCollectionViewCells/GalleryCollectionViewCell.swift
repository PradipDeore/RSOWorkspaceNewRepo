//
//  GalleryCollectionViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/04/24.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblgallerytitle: UILabel!
    @IBOutlet weak var imgGalleryImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgGalleryImage.setCornerRadiusforImage()
    }
    func setData(item : Gallery){
        self.lblgallerytitle.text = item.name
       
        if let imageUrl = item.img, !imageUrl.isEmpty {
            if let url = URL(string: imageBasePath + imageUrl) {
                self.imgGalleryImage.kf.setImage(with: url)
            }
        }
        
    }

}
