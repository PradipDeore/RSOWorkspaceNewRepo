//
//  RSOButton.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 11/02/24.
//

import Foundation
import UIKit

class RSOButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    // MARK: - Private Methods
    
    private func setupButton() {
        let fontColor = UIColor.white
        let backgroundcolor = RSOColors.customBlueColor
        setTitleColor(fontColor, for: .normal)
        //titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        titleLabel?.font = UIFont(name: "Poppins-Bold", size: 15.0)
        backgroundColor = backgroundcolor
        layer.cornerRadius = 18.5
    }
}
extension RSOButton{
    func setCornerRadiusToButton(){
        self.layer.cornerRadius = self.bounds.height / 2
    }
    func setCornerRadiusToButton2(){
        self.layer.cornerRadius = 9.0

    }
}
