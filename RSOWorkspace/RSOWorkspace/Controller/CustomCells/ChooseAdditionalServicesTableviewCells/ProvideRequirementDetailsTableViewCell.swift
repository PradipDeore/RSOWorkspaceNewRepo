//
//  ProvideRequirementDetailsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 07/03/24.
//

import UIKit
import IQKeyboardManagerSwift

class ProvideRequirementDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var txtViewrequirnmentDetails: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldView.setCornerRadiusForView()
      txtViewrequirnmentDetails.addPlaceholder(text: "Provide Requirnment Details")
    }
 
}
