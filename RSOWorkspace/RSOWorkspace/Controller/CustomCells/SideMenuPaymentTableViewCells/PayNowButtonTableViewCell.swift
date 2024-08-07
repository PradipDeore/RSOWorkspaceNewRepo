//
//  PayNowButtonTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/07/24.
//

import UIKit

protocol PayNowButtonTableViewCellDelegate: AnyObject {
    func didTapPayNowButton()
}
class PayNowButtonTableViewCell: UITableViewCell {
    
    weak var delegate: PayNowButtonTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func btnPayNowAction(_ sender: Any) {
        delegate?.didTapPayNowButton()
    }
}

