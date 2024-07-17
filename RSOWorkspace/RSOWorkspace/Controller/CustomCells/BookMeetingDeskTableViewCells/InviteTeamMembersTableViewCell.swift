//
//  InviteTeamMembersTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 04/03/24.
//

import UIKit

protocol InviteTeamMembersTableViewCellDelegate: AnyObject{
    func btnAddTeamMembersTappedAction()
    func btnDeleteTeamMember(buttonTag:Int)

}
class InviteTeamMembersTableViewCell: UITableViewCell {

    weak var delegate: InviteTeamMembersTableViewCellDelegate?
    @IBOutlet weak var containerView: UIView!
   
    @IBOutlet weak var teammemberImage: UIImageView!
    @IBOutlet weak var lblteammemberName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var teamMemberView: UIView!

    @IBOutlet weak var btnAdd: RSOButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.setCornerRadiusForView()
        btnAdd.backgroundColor = .white
        btnAdd.layer.cornerRadius = 0.5 * btnAdd.bounds.size.width
        btnAdd.clipsToBounds = true
        // Initialization code
        self.teammemberImage.setRounded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func btnAddTeamMembersTappedAction(_ sender: Any) {
        delegate?.btnAddTeamMembersTappedAction()
    }
    @IBAction func btndeleTappedAction(_ sender: UIButton) {
        delegate?.btnDeleteTeamMember(buttonTag: sender.tag)
    }
    
}


