//
//  Constants.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 11/02/24.
//

import Foundation
import UIKit

//develop
//let imageBasePath = "https://finance.ardemos.co.in/rso/"
//production server
//let imageBasePath = "https://rso.teamalo.com/"

//liver server
let imageBasePath = "https://www.rsoworkplace.com/"



struct RSOColors {
    static let customBlueColor = UIColor(named: "000000") ?? UIColor.black
    static let customGrayColor = UIColor(named: "C9C9C9") ?? UIColor.gray
    static let customTextFieldBorderColor = UIColor(named: "F0F0F0") ?? UIColor.gray
    static let socialButtonFontColor = UIColor(named: "868686") ?? UIColor.gray
}

struct RSOFont{
    enum FontSize: String {
        case Medium
        case Bold
        case Regular
        case SemiBold
    }
    static func inter(size: CGFloat, type: FontSize) -> UIFont {
        let fontName = "Inter-\(type.rawValue)"
        return  UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func poppins(size: CGFloat, type: FontSize) -> UIFont {
        let fontName = "Poppins-\(type.rawValue)"
        return  UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
