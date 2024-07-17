//
//  ButtonCancelAndSaveTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 03/04/24.
//

import UIKit

protocol ButtonSaveDelegate:AnyObject{
    func btnSaveTappedAction()
}
class ButtonCancelAndSaveTableViewCell: UITableViewCell {

    weak var delegate: ButtonSaveDelegate?
    @IBOutlet weak var btnCancel: RSOButton!
    @IBOutlet weak var btnSave: RSOButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnCancel.backgroundColor = ._768_D_70
    }

  
    @IBAction func btnCancelTappedAction(_ sender: Any) {
        
        
    }
    
    @IBAction func btnSaveTappedAction(_ sender: Any) {
        
        delegate?.btnSaveTappedAction()
        
        
    }
    
}
