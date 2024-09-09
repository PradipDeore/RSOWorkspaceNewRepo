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
                     
                     // Append each amenity name with a bullet point
                     message.append("• \(name)\n")
                 } else if let amenity = amenity as? BookingDeskDetailsFreeAmenity {
                     let name = amenity.name ?? "No Name"
                     
                     // Append each amenity name with a bullet point
                     message.append("• \(name)\n")
                     
                     // Print the details of each amenity for debugging
                     print("Amenity (BookingDeskDetailsFreeAmenity) - Name: \(name)")
                 }
             }
         // Add a newline character to the title to create spacing
             let titleWithSpacing = "\(title)\n"
             
             // Create an attributed string for the title with left alignment and additional spacing after the title
             let titleParagraphStyle = NSMutableParagraphStyle()
             titleParagraphStyle.alignment = .center // Align title to the left

             let attributedTitle = NSAttributedString(string: titleWithSpacing, attributes: [
                 .paragraphStyle: titleParagraphStyle,
                 .font: RSOFont.poppins(size: 16, type: .Bold)
             ])
             
             // Set the title as an attributed string
             alertController.setValue(attributedTitle, forKey: "attributedTitle")
            
            // Handle the case when there are no amenities
            if message.isEmpty {
                let noAmenitiesMessage = "No amenities available."
                
                // Create an attributed string for the centered message
                let centeredParagraphStyle = NSMutableParagraphStyle()
                centeredParagraphStyle.alignment = .center // Align text to the center

                let attributedMessage = NSAttributedString(string: noAmenitiesMessage, attributes: [
                    .paragraphStyle: centeredParagraphStyle,
                    .font: RSOFont.poppins(size: 14, type: .Regular)
                ])
                
                // Set the message as an attributed string
                alertController.setValue(attributedMessage, forKey: "attributedMessage")
            } else {
                // Create an attributed string for the amenities message with line spacing and left alignment
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .left // Align text to the left
                paragraphStyle.lineSpacing = 4.0 // Set line spacing between bullet points

                let attributedMessage = NSAttributedString(string: message, attributes: [
                    .paragraphStyle: paragraphStyle,
                    .font: RSOFont.poppins(size: 14, type: .Regular)
                ])
                
                // Set the message as an attributed string
                alertController.setValue(attributedMessage, forKey: "attributedMessage")
            }

        
        // Add a Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
         self.present(alertController, animated: true, completion: nil)
            print("Parent view controller is nil. Unable to present alert.")
    }
 
}

