//
//  MeetingTimeTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 06/03/24.
//

import UIKit

class MeetingTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var textFieldView: UIView!
   
    @IBOutlet weak var Labelhrs: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        txtTime.setUpTextFieldView(leftImageName: "clock")
        textFieldView.setCornerRadiusForView()
    }

   
    
}
