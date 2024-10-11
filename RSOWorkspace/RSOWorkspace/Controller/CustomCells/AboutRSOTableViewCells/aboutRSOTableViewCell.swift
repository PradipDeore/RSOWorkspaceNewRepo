//
//  aboutRSOTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/04/24.
//

import UIKit

class aboutRSOTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var imgAbout: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(item : AboutRSO){
        self.lblTitle.text = item.sec5Title
        self.lblDescription.text = item.sec5Desc
        
        if let imgUrl = item.sec5Img, !imgUrl.isEmpty {
            if let imageUrl = URL(string: imageBasePath + imgUrl) {
                self.imgAbout.kf.setImage(with: imageUrl)
            }
        }
        //self.imgAbout.image = UIImage(named: item.sec5Img ?? "")
    }
   
    
}
