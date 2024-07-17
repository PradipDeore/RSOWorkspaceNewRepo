//
//  ProvideDetailsOfIssueTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/03/24.
//

import UIKit
protocol DescriptionDelegate:AnyObject{
    func sendDescription(txtDescription:String)
}
class ProvideDetailsOfIssueTableViewCell: UITableViewCell {
   
    @IBOutlet weak var textFieldView: UITextView!
    weak var delegate: DescriptionDelegate?
    var descriptionText: String = "" {
        didSet {
            delegate?.sendDescription(txtDescription: descriptionText)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textFieldView.layer.cornerRadius = 8
        textFieldView.delegate = self
        textFieldView.addPlaceholder(text: "Please provide your requirement details")
    }
}

extension ProvideDetailsOfIssueTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        descriptionText = textView.text // Update the descriptionText property when text changes
    }
}

