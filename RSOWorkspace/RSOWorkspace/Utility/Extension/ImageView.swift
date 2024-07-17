//
//  ImageView.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/04/24.
//

import Foundation
import UIKit
extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}
