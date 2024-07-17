//
//  RSOSocialButton.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 17/02/24.
//

import Foundation
import UIKit

class RSOSocialButton: UIButton {
    
    // MARK: - Properties
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        let fontColor = RSOColors.socialButtonFontColor
        label.textColor = fontColor
        label.font = RSOFont.inter(size: 14, type: .Regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Setup
    
    private func commonInit() {
        // Add subviews
        addSubview(iconImageView)
        addSubview(nameLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 90),
        ])
        layer.cornerRadius = 10
    }
    
    // MARK: - Configuration
    
    func configure(with image: UIImage?, title: String?) {
        iconImageView.image = image
        nameLabel.text = title
    }
}
