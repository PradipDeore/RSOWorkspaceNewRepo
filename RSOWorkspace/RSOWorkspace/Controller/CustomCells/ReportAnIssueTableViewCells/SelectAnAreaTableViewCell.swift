//
//  SelectAnAreaTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/03/24.
//

import UIKit
protocol SelectAnAreaTableViewCellDelegate: AnyObject {
    func dropdownButtonTapped(selectedOption: Location)
    func presentAlertController(alertController: UIAlertController)
}
class SelectAnAreaTableViewCell: UITableViewCell {

    weak var delegate: SelectAnAreaTableViewCellDelegate?

    @IBOutlet weak var txtSelectAnArea: UITextField!
    @IBOutlet weak var textFieldView: UIView!
    var dropdownOptions: [Location] = [] // Add dropdownOptions property

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textFieldView.setCornerRadiusForView()
        txtSelectAnArea.setUpTextFieldView(leftImageName:"",rightImageName: "arrowdown")
    }

    @IBAction func dropdownButtonTapped(_ sender: Any) {
           let alertController = UIAlertController(title: "Select Location", message: nil, preferredStyle: .actionSheet)
           
           for option in dropdownOptions {
               let action = UIAlertAction(title: option.name, style: .default) { [weak self] _ in
                   // Handle option selection
                   print("Selected option: \(option.name)")
                   // Assign the selected option to the text field
                   self?.txtSelectAnArea.text = option.name
                   
                   // Notify the delegate about the selected option
                   self?.delegate?.dropdownButtonTapped(selectedOption: option)
               }
               alertController.addAction(action)
           }
           
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           alertController.addAction(cancelAction)
        // Present the alert controller via delegate
        if let delegate = delegate{
            delegate.presentAlertController(alertController: alertController)
        }
    }
}
