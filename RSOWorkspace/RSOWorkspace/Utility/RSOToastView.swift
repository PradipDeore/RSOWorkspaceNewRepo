//
//  RSOToastView.swift
//  NewGulfPharmacy
//
//  Created by Sumit Aquil on 14/07/24.
//

import Foundation
import UIKit
import Toast_Swift

class RSOToastView {
    static let shared = RSOToastView()
    func show(_ msg: String?, duration: TimeInterval = ToastManager.shared.duration, position: ToastPosition = ToastManager.shared.position) {
        UIApplication.shared.topViewController?.view.makeToast(msg, duration: duration, position: position)
    }
}
