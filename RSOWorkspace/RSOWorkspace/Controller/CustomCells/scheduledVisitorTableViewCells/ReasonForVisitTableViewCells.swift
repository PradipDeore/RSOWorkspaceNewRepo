//
//  ReasonForVisitTableViewCells.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 03/04/24.
//

import UIKit

protocol ReasonForVisitTableViewCellDelegate: AnyObject {
    func dropdownButtonTapped(selectedOption: Reason)
    func presentAlertController(alertController: UIAlertController)
}
class ReasonForVisitTableViewCells: UITableViewCell {

    weak var delegate: ReasonForVisitTableViewCellDelegate?

    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    var dropdownOptions: [Reason] = [] // Add dropdownOptions property

    @IBOutlet weak var txtSelectReason: UITextField!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customizeCell()
        self.txtSelectReason.setUpTextFieldView(rightImageName:"arrowdown")
    }
    func customizeCell(){
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        
        let shadowColor = UIColor.black.withAlphaComponent(0.5)
        self.containerView.layer.shadowColor = shadowColor.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.containerView.layer.shadowRadius = 10.0
        self.containerView.layer.shadowOpacity = 19.0
        self.containerView.layer.masksToBounds = false
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect:  CGRect(x: 0, y: self.containerView.bounds.height - 4, width: self.containerView.bounds.width, height: 4), cornerRadius: self.containerView.layer.cornerRadius).cgPath
    }
    func resetReasonTextFields(){
        txtSelectReason.text = ""
       
    }
    @IBAction func dropdownButtonTapped(_ sender: Any) {
           let alertController = UIAlertController(title: "Select Reason", message: nil, preferredStyle: .actionSheet)
           
           for option in dropdownOptions {
               let action = UIAlertAction(title: option.reason, style: .default) { [weak self] _ in
                   // Handle option selection
                   print("Selected reason: \(option.reason)")
                   // Assign the selected option to the text field
                   self?.txtSelectReason.text = option.reason
                   
                   // Notify the delegate about the selected option
                   self?.delegate?.dropdownButtonTapped(selectedOption: option)
               }
               alertController.addAction(action)
           }
           
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           alertController.addAction(cancelAction)
        // Present the alert controller via delegate
               if let delegate = delegate {
                   delegate.presentAlertController(alertController: alertController)
               }
           
       }
   
}
