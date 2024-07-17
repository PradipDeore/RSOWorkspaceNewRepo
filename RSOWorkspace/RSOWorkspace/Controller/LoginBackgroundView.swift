//
//  LoginBackgroundView.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 16/02/24.
//

import UIKit

class LoginBackgroundView: UIView {
    
    // Subviews
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "circle1") // Set your left image name here
        return imageView
    }()
    
    private let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "circle2") // Set your right image name here
        return imageView
    }()
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // Setup views and constraints
    private func setupViews() {
        // Background color
        backgroundColor = RSOColors.customGrayColor
        // Custom UIColor initializer with hex value
        
        // Add subviews
        addSubview(leftImageView)
        addSubview(rightImageView)
        
        // Constraints for leftImageView
        NSLayoutConstraint.activate([
            leftImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftImageView.topAnchor.constraint(equalTo: topAnchor),
            leftImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftImageView.widthAnchor.constraint(equalToConstant: 118) // Width as per your requirement
        ])
        
        // Constraints for rightImageView
        NSLayoutConstraint.activate([
            rightImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightImageView.topAnchor.constraint(equalTo: topAnchor),
            rightImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightImageView.widthAnchor.constraint(equalToConstant: 128) // Width as per your requirement
        ])
        // Set content mode for image views
            leftImageView.contentMode = .scaleAspectFit
            rightImageView.contentMode = .scaleAspectFit
    }
}
