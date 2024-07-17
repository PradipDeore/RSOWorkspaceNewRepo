//
//  VerifyViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/02/24.
//

import UIKit

class VerifyViewController: UIViewController {
    
    @IBOutlet weak var txtVerify1: UITextField!
    @IBOutlet weak var txtVerify2: UITextField!
    @IBOutlet weak var txtVerify3: UITextField!
    @IBOutlet weak var txtVerify4: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func customizeUI(){
        customizeTextfield(textField: txtVerify1)
        customizeTextfield(textField: txtVerify2)
        customizeTextfield(textField: txtVerify3)
        customizeTextfield(textField: txtVerify4)
     }
    
    func customizeTextfield(textField: UITextField){
        textField.layer.cornerRadius = 10.0 // Customize as per your requirement
        textField.layer.borderColor = RSOColors.customGrayColor.cgColor
        textField.layer.borderWidth = 1.14
        textField.textColor = .black
        textField.font = RSOFont.inter(size: 20,type: .Medium)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }
    
    
    // Handle text field changes
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.count == 1 {
            switch textField {
            case txtVerify1:
                txtVerify2.becomeFirstResponder()
            case txtVerify2:
                txtVerify3.becomeFirstResponder()
            case txtVerify3:
                txtVerify4.becomeFirstResponder()
            case txtVerify4:
                txtVerify4.resignFirstResponder()
                // Perform verification or any other action when OTP is complete
                print("OTP entered: \(getOTP())")
            default:
                break
            }
        }
    }
    
    // Get the OTP from the text fields
    func getOTP() -> String {
        return "\(txtVerify1.text!)\(txtVerify2.text!)\(txtVerify3.text!)\(txtVerify4.text!)"
    }
    
    // Dismiss keyboard when user taps outside the text fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
