//
//  SelectNoOfSeatsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 27/07/24.
//

import UIKit

protocol SelectNoOfSeatsTableViewCellDelegate: AnyObject {
    func didUpdateNumberOfSeats(_ numberOfSeats: Int)
}
class SelectNoOfSeatsTableViewCell: UITableViewCell {

    weak var delegate: SelectNoOfSeatsTableViewCellDelegate?
    @IBOutlet weak var txtNoOfSeats: UITextField!
    @IBOutlet weak var btnMinus: RSOButton!
    @IBOutlet weak var btnPlus: RSOButton!
    var isOfficeSelected = false  // Add a flag to check if an office is selected

    var noOfMaxSeatsToBook = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        setButtonsANDTextFields()
    }

    
    @IBAction func btnIncrementSeatsCount(_ sender: Any) {
        if !isOfficeSelected {
                    // If office is not selected, show a message and return
                    RSOToastView.shared.show("Please select an office first.", duration: 2.0, position: .center)
                    return
                }

//        if let currentCount = Int(txtNoOfSeats.text ?? "1") {
//                    let updatedCount = currentCount + 1
//                    txtNoOfSeats.text = "\(updatedCount)"
//                    delegate?.didUpdateNumberOfSeats(updatedCount)
//                } else {
//                    txtNoOfSeats.text = "1"
//                    delegate?.didUpdateNumberOfSeats(1)
//                }
        if let currentCount = Int(txtNoOfSeats.text ?? "1") {
               // Check if the updated count exceeds the maximum allowed seats
               if currentCount < noOfMaxSeatsToBook {
                   let updatedCount = currentCount + 1
                   txtNoOfSeats.text = "\(updatedCount)"
                   delegate?.didUpdateNumberOfSeats(updatedCount)
               } else {
                   // Display toast message if the limit is exceeded
                   RSOToastView.shared.show("You can only book up to \(noOfMaxSeatsToBook) seats.", duration: 2.0, position: .center)
               }
           } else {
               // Set to 1 if the text field has invalid data
               txtNoOfSeats.text = "1"
               delegate?.didUpdateNumberOfSeats(1)
           }
    }
    
    @IBAction func btnDecrementSeatsCount(_ sender: Any) {
        if !isOfficeSelected {
                    // If office is not selected, show a message and return
                    RSOToastView.shared.show("Please select an office first.", duration: 2.0, position: .center)
                    return
                }

        if let currentCount = Int(txtNoOfSeats.text ?? "1"), currentCount > 1 {
                    let updatedCount = currentCount - 1
                    txtNoOfSeats.text = "\(updatedCount)"
                    delegate?.didUpdateNumberOfSeats(updatedCount)
                } else {
                    txtNoOfSeats.text = "1"
                    delegate?.didUpdateNumberOfSeats(1)
                }
    }
    
    func setButtonsANDTextFields(){
        self.btnMinus.layer.cornerRadius = btnMinus.bounds.height / 2
        self.btnPlus.layer.cornerRadius = btnPlus.bounds.height / 2
        
    }
    
    func updateOfficeSelectionStatus(_ isSelected: Bool) {
        self.isOfficeSelected = isSelected
          print("Office selected: \(isSelected)")  // Add this to debug
       }
    
}
