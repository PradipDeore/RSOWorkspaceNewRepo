//
//  OnDemandServiceCollectionViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 16/03/24.
//

import UIKit
import Kingfisher

class OnDemandServiceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var containerView: UIView!
   
    var cornerRadius: CGFloat = 10.0

    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
    }
    func customizeCell(){
        self.containerView.setCornerRadiusForView()
    }
    func setData(item : Service){
        self.lblService.text = item.title
        let imageUrl = item.image
        if !imageUrl.isEmpty{
            let url = URL(string: imageBasePath + imageUrl)
            self.imgService.kf.setImage(with: url)
        }
    }

}
