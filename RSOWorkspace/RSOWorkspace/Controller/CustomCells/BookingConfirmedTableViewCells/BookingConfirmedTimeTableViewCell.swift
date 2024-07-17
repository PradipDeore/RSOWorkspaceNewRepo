//
//  BookingConfirmedTimeTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/03/24.
//

import UIKit

class BookingConfirmedTimeTableViewCell: UITableViewCell {
   
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var textFieldView: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        txtTime.setUpTextFieldView(leftImageName: "location")
        textFieldView.setCornerRadiusForView()
    }
    
    
}
