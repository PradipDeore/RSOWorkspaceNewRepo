//
//  UITextView.swift
//  NewGulfPharmacy
//
//  Created by Sumit Aquil on 07/05/24.
//

import Foundation
import UIKit
extension UITextView {
    func addPlaceholder(text: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = text
        placeholderLabel.font = RSOFont.inter(size: 14, type: .Regular)
        placeholderLabel.textColor = UIColor(named: "828282")?.withAlphaComponent(0.8)
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            placeholderLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: self, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }
}
