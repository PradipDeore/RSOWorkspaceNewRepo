//
//  BookingConfirmedLocationTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/03/24.
//

import UIKit

class BookingConfirmedLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var textFieldView: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        textFieldView.setCornerRadiusForView()
        txtLocation.setUpTextFieldView(leftImageName: "location")
    }
   

    
}
