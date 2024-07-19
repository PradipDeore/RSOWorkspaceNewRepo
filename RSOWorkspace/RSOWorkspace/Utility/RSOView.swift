//
//  RSOView.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 20/02/24.
//

import Foundation
import UIKit
import UIKit

@IBDesignable
class ShadowedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.black.withAlphaComponent(0.25) {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 4) {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }
    }
    
  @IBInspectable var shadowRadius: CGFloat = 4.0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false // Must be false for shadow to be visible
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
}

extension UIView {
    func addShadow(){
        let shadowColor = UIColor.black.withAlphaComponent(0.5)
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:  CGRect(x: 25, y: self.bounds.height - 4, width: self.bounds.width, height: 4), cornerRadius: 10).cgPath
    }
    func setCornerRadiusForView(){
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
    }
    
}
extension UIView {
    func addHorizontalLine(color: UIColor, height: CGFloat) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)
        
        // Constraints for the line view
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: height),
            lineView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
