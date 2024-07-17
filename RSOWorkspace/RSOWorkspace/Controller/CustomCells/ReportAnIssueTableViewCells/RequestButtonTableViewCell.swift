//
//  RequestButtonTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/03/24.
//

import UIKit

protocol RequestButtonTableViewCellDelegate:AnyObject{
    func requestButtonTapped()
}

class RequestButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var btnRequest: RSOButton!
    
    weak var delegate: RequestButtonTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnRequest.layer.cornerRadius = btnRequest.bounds.height / 2
    }

   
    @IBAction func btnRequestTappedAction(_ sender: Any) {
        delegate?.requestButtonTapped()
        
    }
    
}
