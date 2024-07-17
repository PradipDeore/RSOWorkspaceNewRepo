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
        // Initialization code
    }
    func setData(item : GalleryResponseModel){
        self.lblgallerytitle.text = item.title
        self.imgGalleryImage.image = UIImage(named: item.galleryimageName)
        
    }

}
