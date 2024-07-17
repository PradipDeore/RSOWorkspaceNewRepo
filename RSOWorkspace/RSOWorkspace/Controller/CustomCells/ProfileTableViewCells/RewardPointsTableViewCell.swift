//
//  RewardPointsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/04/24.
//

import UIKit

class RewardPointsTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: ShadowedView!
    @IBOutlet weak var lblPoints: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    func setData(item: MyProfile){
        if let rewardpoint = item.data.rewardPoints{
            self.lblPoints.text = String(rewardpoint)
        }
    }
}
