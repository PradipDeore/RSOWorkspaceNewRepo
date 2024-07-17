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
        self.lblTitle.text = item.title
        self.lblDescription.text = item.description
        self.imgAbout.image = UIImage(named: item.imageName)
    }
   
    
}
