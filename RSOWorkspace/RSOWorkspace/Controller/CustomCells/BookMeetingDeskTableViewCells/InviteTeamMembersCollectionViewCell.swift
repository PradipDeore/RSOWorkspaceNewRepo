//
//  InviteTeamMembersCollectionViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 04/03/24.
//

import UIKit

class InviteTeamMembersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var inviteMemberView: UIView!
    @IBOutlet weak var teammemberImage: UIImageView!
    @IBOutlet weak var lblteammemberName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.teammemberImage.layer.cornerRadius = min(bounds.width, bounds.height) / 2.0
        self.teammemberImage.layer.masksToBounds = true
    }

}
