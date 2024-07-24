//
//  RSVPButtonViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 22/03/24.
//

import UIKit
import Toast_Swift
import IQKeyboardManagerSwift

class RSVPButtonViewController: UIViewController {
    
    @IBOutlet weak var rsvpView: UIView!
    @IBOutlet weak var txtName: RSOTextField!
    @IBOutlet weak var txtCompany: RSOTextField!
    @IBOutlet weak var txtEmail: RSOTextField!
    @IBOutlet weak var txtPhone: RSOTextField!
    @IBOutlet weak var btnRSVP: RSOButton!
    
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    var rsvpResponseData: rsvpResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.placeholderText = "Your Name"
        txtName.placeholderFont = RSOFont.inter(size: 16, type: .Medium)
        txtName.customBorderWidth = 0.0
        
        txtCompany.placeholderText = "Company"
        txtCompany.placeholderFont = RSOFont.inter(size: 16, type: .Medium)
        txtCompany.customBorderWidth = 0.0
        
        txtEmail.placeholderText = "Your Email"
        txtEmail.placeholderFont = RSOFont.inter(size: 16, type: .Medium)
        txtEmail.customBorderWidth = 0.0
        
        txtPhone.placeholderText = "Your Phone"
        txtPhone.placeholderFont = RSOFont.inter(size: 16, type: .Medium)
        txtPhone.customBorderWidth = 0.0
        
    }
    
    func rsvpAPI(name :String, companyname:String,email:String,phone: String) {
        let requestModel = rsvpRequestModel(name: name, companyName: companyname, email: email, phone: phone)
        print("requestModel",requestModel)
        APIManager.shared.request(
            modelType: rsvpResponse.self,
            type: CommuneEndPoint.rsvp(requestModel: requestModel)) { response in
                switch response {
                case .success(let response):
                    self.rsvpResponseData = response
                    
                    //record inserted successfully
                    DispatchQueue.main.async {
                        RSOToastView.shared.show("\(response.message)", duration: 3.0, position: .center)
                    }
                    
                    // Pause execution for 5 seconds using DispatchQueue
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        // Dismiss the view controller after 5 seconds
                        self.dismiss(animated: true, completion: nil)
                        let communeVC = UIViewController.createController(storyBoard: .TabBar, ofType:  CommuneViewController.self)
                        self.navigationController?.pushViewController(communeVC, animated: true)
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                        //  Unsuccessful
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    @IBAction func btnRSVPTappedAction(_ sender: Any) {
        
        guard let name = txtName.text, !name.isEmpty,
              let company = txtCompany.text, !company.isEmpty,
              let email = txtEmail.text, !email.isEmpty,
              let phone = txtPhone.text, !phone.isEmpty else {
            // Show an error message for any missing or empty field
            RSOToastView.shared.show("All fields are required", duration: 2.0, position: .center)
            return
        }
        
        // Check if email is valid
        guard RSOValidator.isValidEmail(email) else {
            RSOToastView.shared.show("Invalid email", duration: 2.0, position: .center)
            return
        }
        
        // Check if phone number is valid
        guard RSOValidator.validatePhoneNumber(phone) else {
            RSOToastView.shared.show("Phone Number must contain at least 10 digits", duration: 2.0, position: .center)
            return
        }
        rsvpAPI(name: name, companyname: company, email: email, phone: phone)
    }
    
    @IBAction func btnDismissView(_ sender: Any) {
        dismiss(animated: true)
        
    }
}
extension RSVPButtonViewController {
    enum Event {
        
        case dataLoaded
        case error(Error?)
    }
}
