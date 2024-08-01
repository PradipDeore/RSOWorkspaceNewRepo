//
//  UILabel.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 27/03/24.
//

import Foundation
import UIKit
extension UILabel {
    func addUnderline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
    }
    
    func makeCircular() {
           self.layer.cornerRadius = self.frame.size.width / 2
           self.layer.masksToBounds = true
       }
}
