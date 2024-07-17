//
//  ButtonPayNowTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 07/03/24.
//

import UIKit

protocol ButtonPayNowTableViewCellDelegate:AnyObject{
    func btnPayNowTappedAction()
}
class ButtonPayNowTableViewCell: UITableViewCell {

    weak var delegate : ButtonPayNowTableViewCellDelegate?
    @IBOutlet weak var btnPayNow: RSOButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnPayNowTappedAction(_ sender: Any) {
        delegate?.btnPayNowTappedAction()
    }
    
    
}
