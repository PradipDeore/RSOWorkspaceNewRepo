//
//  CompaniesListTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 21/03/24.
//

import UIKit
protocol ButtonBrowseMambersDelegate:AnyObject{
    func btnBrowseMembersTappedAction(index:Int)
}

class CompaniesListTableViewCell: UITableViewCell {

    weak var delegate : ButtonBrowseMambersDelegate?
    @IBOutlet weak var btnCall: RSOButton!
    @IBOutlet weak var btnBrowseMembers: RSOButton!
   
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblCompaniesSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnCall.layer.cornerRadius = 9.0
        self.btnBrowseMembers.layer.cornerRadius = btnBrowseMembers.bounds.height / 2
    }

    @IBAction func btnBrowseMembersTappedActDelegate(_ sender: Any) {
        
        delegate?.btnBrowseMembersTappedAction(index: self.tag)
    }
    func setData(item : Company){
        self.lblCompanyName.text = item.name
        self.lblCompaniesSubtitle.text = item.description
    }
    
}
