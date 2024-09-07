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
    
    case Membership
}

extension UIViewController {
    class func createController<T: UIViewController>(storyBoard: SBName, ofType type: T.Type) -> T {
        let storyboard = UIStoryboard(name: storyBoard.rawValue, bundle: nil)
        return (storyboard.instantiateViewController(withIdentifier: String(describing: type)) as? T)!
    }
    
    // Helper function to show the alert for amenities
     func showAmenitiesAlert(amenities: [Any], title: String) {
        // Create an alert controller
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        // Create the bullet points for the amenities
        var message = ""
        for amenity in amenities {
            if let amenity = amenity as? AmenityFree {
                let name = amenity.name ?? "No Name"
                let description = amenity.description ?? "No Description"
                
                // Append each amenity with titles for name and description
                message.append("• Amenity Name: \(name)\n")
                message.append("  Description: \(description)\n\n")
            } else if let amenity = amenity as? BookingDeskDetailsFreeAmenity {
                let name = amenity.name ?? "No Name"
                let description = amenity.description ?? "No Description"
                
                // Append each amenity with titles for name and description
                message.append("• Amenity Name: \(name)\n")
                message.append("  Description: \(description)\n\n")
                // Print the details of each amenity for debugging
                print("Amenity (BookingDeskDetailsFreeAmenity) - Name: \(name), Description: \(description)")
            }
        }
        // Check if message is empty
            if message.isEmpty {
                message = "No amenities available."
            }
        alertController.message = message
        
        // Add a Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
         self.present(alertController, animated: true, completion: nil)
            print("Parent view controller is nil. Unable to present alert.")
    }
 
}

