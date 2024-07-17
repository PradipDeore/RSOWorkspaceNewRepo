//
//  ComapaniesSearchMembersTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/03/24.
//

import UIKit

protocol LabelMemberNameTappedDelegate:AnyObject{
    func showCard(for member: Member,  membercompany:String)
}
class ComapaniesSearchMembersTableViewCell: UITableViewCell {
    
    weak var delegateShowCard:LabelMemberNameTappedDelegate?
    @IBOutlet weak var lblMemberName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    

    
}
