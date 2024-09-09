//
//  SelectLocationTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 29/02/24.
//

import UIKit

protocol SelectLocationTableViewCellDelegate: AnyObject {
    func dropdownButtonTapped(selectedOption: LocationDetails)
    func presentAlertController(alertController: UIAlertController)
}

class SelectLocationTableViewCell: UITableViewCell {
    
    weak var delegate: SelectLocationTableViewCellDelegate?
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    var dropdownOptions: [LocationDetails] = [] // Add dropdownOptions property
    // Define the default location
       // let defaultLocation = "Reef Tower"
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
        txtLocation.setUpTextFieldView(leftImageName: "location", rightImageName: "arrowdown")
        // Set default location as "Reef Tower"
        //setDefaultLocation()
    }
    
//    func setDefaultLocation() {
//            // Set the default location to "Reef Tower"
//            txtLocation.text = defaultLocation
//
//            // Disable dropdown if the default value is set
//            if txtLocation.text == defaultLocation {
//                dropdownButton.isEnabled = false
//                dropdownButton.isHidden = true  // You can also hide the button
//            } else {
//                dropdownButton.isEnabled = true
//                dropdownButton.isHidden = false
//            }
//       }
    func customizeCell(){
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        self.txtLocation.backgroundColor = .EFEFEF
        self.addShadow()
    }
    @IBAction func dropdownButtonTapped(_ sender: Any) {
    
        let alertController = UIAlertController(title: "Select Location", message: nil, preferredStyle: .actionSheet)
        
        for option in dropdownOptions {
            let action = UIAlertAction(title: option.name, style: .default) { [weak self] _ in
                // Handle option selection
                print("Selected option: \(option.name)")
                // Assign the selected option to the text field
                
                self?.txtLocation.text = option.name
                // Notify the delegate about the selected option
                self?.delegate?.dropdownButtonTapped(selectedOption: option)
                // Update the UI if the selected value is Reef Tower
               // self?.setDefaultLocation()
            }
            alertController.addAction(action)
            // Check if the current option matches the default value "Reef Tower"
          
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        // Present the alert controller via delegate
        if let delegate = delegate {
            delegate.presentAlertController(alertController: alertController)
        }
        
    }
    
}
