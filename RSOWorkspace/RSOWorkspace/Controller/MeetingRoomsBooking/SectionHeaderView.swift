//
//  SectionHeaderView.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 12/04/24.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    
    let sectionLabel = UILabel()
    var labelHeight: CGFloat = 30 // Default height

       override init(reuseIdentifier: String?) {
           super.init(reuseIdentifier: reuseIdentifier)
           
           // Configure day label
           sectionLabel.textAlignment = .left
           sectionLabel.font = RSOFont.poppins(size: 14, type: .SemiBold)
           addSubview(sectionLabel)
           
       }
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Remove existing constraints
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.removeConstraints(sectionLabel.constraints)
        
        // Add new constraints
        NSLayoutConstraint.activate([
            sectionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            sectionLabel.topAnchor.constraint(equalTo: self.topAnchor),
            sectionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            sectionLabel.heightAnchor.constraint(equalToConstant: labelHeight) // Use labelHeight for the height

        ])
    }
    

}
