//
//  SignUpViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/02/24.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import AuthenticationServices

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: RSOTextField!
    @IBOutlet weak var txtPassword: RSOTextField!
    @IBOutlet weak var txtPhone: RSOTextField!
    
    @IBOutlet weak var txtFullName: RSOTextField!
    
  
    
    var eventHandler: ((_ event: Event, _ message: String) -> Void)? // Data Binding Closure
    var signupResponseData: SignUpResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addEventHandler()
        self.customizeUI()
      
        
    }
    func customizeUI(){
        txtFullName.placeholderText = "Your Full Name"
        txtEmail.placeholderText = "Your email"
        txtPassword.placeholderText = "Password"
        txtPhone.placeholderText = "Your phone number"
        txtPassword.addPasswordToggle()
  
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
       
    func addEventHandler() {
        self.eventHandler = { [weak self] (event, message) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch event {
                case .dataLoaded:
                    // Display the response message as a toast
                    RSOToastView.shared.show(message, duration: 2.0, position: .center)
                    
                    // Check if the signup response status is true
                    if let signupResponse = self.signupResponseData, signupResponse.status {
                        // If signup is successful, pop the view controller after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    // If status is false, the toast will already be shown and the user will remain on the same screen
                case .error(let errorMessage):
                    // Display the error message as a toast
                    RSOToastView.shared.show(message, duration: 2.0, position: .center)
                }
            }
        }
    }
    
    func signUpAPI(fullName:String,email: String, password: String, phone: String) {
        let requestModel = SignUpRequestModel(name: fullName, email: email, password: password, phone: phone)
        APIManager.shared.request(
            modelType: SignUpResponse.self,
            type: LogInSignUpEndPoint.signUp(requestModel: requestModel)) { response in
                switch response {
                case .success(let response):
                    self.signupResponseData = response
                    self.eventHandler?(.dataLoaded, response.message)
                case .failure(let error):
                    self.eventHandler?(.error(error), error.localizedDescription)
                }
            }
    }
   
    @IBAction func btnSubmitTappedAction(_ sender: Any) {
        
        guard let fullName = txtFullName.text, !fullName.isEmpty else {
            RSOToastView.shared.show("Please Full Name", duration: 2.0, position: .center)
            return
        }
        // Check if email is valid
        if !RSOValidator.isValidName(fullName) {
            RSOToastView.shared.show("Please enter a valid full name containing only alphabetic characters.", duration: 2.0, position: .center)
            return
        }

        guard let email = txtEmail.text, !email.isEmpty else {
            RSOToastView.shared.show("Please enter your email", duration: 2.0, position: .center)
            return
        }
        // Check if email is valid
        if !RSOValidator.isValidEmail(email) {
            RSOToastView.shared.show("Invalid email", duration: 2.0, position: .center)
            return
        }
        guard let password = txtPassword.text, !password.isEmpty else {
            RSOToastView.shared.show("Please enter your password", duration: 2.0, position: .center)
            return
        }
        // Check if password is valid
        if !RSOValidator.isValidPassword(password) {
            RSOToastView.shared.show("The password must be more than 8 characters, at least 1 lower case, 1 upper case, 1 digit", duration: 2.0, position: .center)
            return
        }
        guard let phone = txtPhone.text, !phone.isEmpty else{
            RSOToastView.shared.show("Please enter your phone",duration: 2.0,position: .center)
            return
        }
        // check if phone number is valid
//        if !RSOValidator.validateDubaiPhoneNumber(phone) {
//            RSOToastView.shared.show("Please enter a valid Dubai phone number with at least 9 digits", duration: 2.0, position: .center)
//            return
//        }
        
        signUpAPI(fullName: fullName, email: email, password: password, phone: phone)
        
    }
}
extension SignUpViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}



