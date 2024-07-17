//
//  NotificationTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/04/24.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setNotifications(item : Notifications){
        if let imgUrl = item.image, !imgUrl.isEmpty {
            if let imageUrl = URL(string: imageBasePath + imgUrl) {
                self.imgNotification.kf.setImage(with: imageUrl)
            }
        }
        self.lblDescription.text = item.description
    }
   
}
