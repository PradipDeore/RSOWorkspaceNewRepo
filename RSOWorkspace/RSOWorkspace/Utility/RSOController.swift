//
//  RSOController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 17/02/24.
//

import Foundation
import UIKit

enum SBName: String {
    case Main
    case GetStarted
    case Products
    case TabBar
    case Booking
    case Payment
    case ConciergeStoryboard
    case Commune
    case Profile
    case Feedback
    case VisitorManagement
    case Dashboard
    case Notifications
    case OfficeBooking
    
}

extension UIViewController {
    class func createController<T: UIViewController>(storyBoard: SBName, ofType type: T.Type) -> T {
        let storyboard = UIStoryboard(name: storyBoard.rawValue, bundle: nil)
        return (storyboard.instantiateViewController(withIdentifier: String(describing: type)) as? T)!
    }
 
}
