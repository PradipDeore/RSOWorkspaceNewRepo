//
//  RSOLoader.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 18/07/24.
//

import Foundation
import ProgressHUD
import UIKit

class RSOLoader {
    static func showLoader() {
        ProgressHUD.colorHUD = .systemGray
        ProgressHUD.colorBackground = .clear
        ProgressHUD.animate()
    }
    static func removeLoader() {
        ProgressHUD.dismiss()
    }
}
