//
//  NotificationDescTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 04/10/24.
//

import UIKit

class NotificationDescTableViewCell: UITableViewCell {
   
    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        notificationView.setCornerRadiusForView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setNotificationsDetails(item : NotificationData){
        if let imgUrl = item.image, !imgUrl.isEmpty {
            if let imageUrl = URL(string: imageBasePath + imgUrl) {
                self.notificationImage.kf.setImage(with: imageUrl)
            }
        }
        self.lbltitle.text = item.name
        self.lblDesc.text = item.description
    }
   
    
}
