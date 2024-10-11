//
//  TermsAndConditionsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 04/10/24.
//

import UIKit

protocol TermsAndConditionsDelegate: AnyObject {
    func didToggleTermsCheckbox(isSelected: Bool)
}

class TermsAndConditionsTableViewCell: UITableViewCell {

    weak var delegate: TermsAndConditionsDelegate? // Delegate property

    @IBOutlet weak var btnTermsAndConditions: UIButton!
    @IBOutlet weak var lblTermsAndConditionsLink: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTermsAndConditionsLink()
    }
    
    @IBAction func btnCheckboxAction(_ sender: Any) {
        self.btnTermsAndConditions.isSelected.toggle()
        delegate?.didToggleTermsCheckbox(isSelected: self.btnTermsAndConditions.isSelected)

    }
    private func setupTermsAndConditionsLink() {
           let termsText = "I agree to the Terms and Conditions, Payment Terms, Refund, Return and Cancellation Policy"
           let attributedString = NSMutableAttributedString(string: termsText)
           
           // Define the range for the link text
           let linkRange = (termsText as NSString).range(of: "Terms and Conditions, Payment Terms, Refund, Return and Cancellation Policy")
           
           // Set the link color (blue)
           attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: linkRange)
           attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: linkRange)
           
           lblTermsAndConditionsLink.attributedText = attributedString
           
           // Enable user interaction on the label
           lblTermsAndConditionsLink.isUserInteractionEnabled = true
           
           // Add tap gesture recognizer to the label
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
           lblTermsAndConditionsLink.addGestureRecognizer(tapGesture)
       }
       
       @objc private func labelTapped(_ gesture: UITapGestureRecognizer) {
           let termsText = "I agree to the Terms and Conditions, Payment Terms, Refund, Return and Cancellation Policy"
           let linkRange = (termsText as NSString).range(of: "Terms and Conditions, Payment Terms, Refund, Return and Cancellation Policy")

           // Check if the tap location is within the link range
           let location = gesture.location(in: lblTermsAndConditionsLink)
           let textStorage = NSTextStorage(attributedString: lblTermsAndConditionsLink.attributedText!)
           let textContainer = NSTextContainer(size: lblTermsAndConditionsLink.bounds.size)
           let layoutManager = NSLayoutManager()
           
           layoutManager.addTextContainer(textContainer)
           textContainer.lineFragmentPadding = 0.0
           textContainer.lineBreakMode = .byWordWrapping
           textContainer.size = lblTermsAndConditionsLink.bounds.size
           textStorage.addLayoutManager(layoutManager)
           
           // Correctly call the method with the new argument label
               let index = layoutManager.glyphIndex(for: location, in: textContainer, fractionOfDistanceThroughGlyph: nil)
           
           // If tapped within the link range, open the URL
           if linkRange.location <= index && index < linkRange.location + linkRange.length {
               if let url = URL(string: "https://www.rsoworkplace.com/terms-and-conditions") {
                   UIApplication.shared.open(url)
               }
           }
       }

    
    
   
    
}
