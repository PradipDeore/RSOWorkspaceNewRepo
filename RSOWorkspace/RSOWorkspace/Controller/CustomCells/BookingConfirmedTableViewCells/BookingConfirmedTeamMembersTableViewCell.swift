//
//  BookingConfirmedTeamMembersTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/03/24.
//

import UIKit

class BookingConfirmedTeamMembersTableViewCell: UITableViewCell  {
    
    @IBOutlet weak var teamMembersView: UIView!
    @IBOutlet weak var lblName: UILabel!

    @IBOutlet weak var teamMemberPhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        teamMembersView.setCornerRadiusForView()
    }

}
