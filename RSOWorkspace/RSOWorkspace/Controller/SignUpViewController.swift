//
//  SignUpViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/02/24.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var txtEmail: RSOTextField!
    @IBOutlet weak var txtPassword: RSOTextField!
    @IBOutlet weak var txtPhone: RSOTextField!
    @IBOutlet weak var btnSocialApple: RSOSocialButton!
    @IBOutlet weak var btnSocialFacebook: RSOSocialButton!
    @IBOutlet weak var btnSocialGoogle: RSOSocialButton!
    
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    var signupResponseData: SignUpResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeUI()
    }
    func customizeUI(){
        txtEmail.placeholderText = "Your email"
        txtPassword.placeholderText = "Password"
        txtPhone.placeholderText = "Your phone number"
        txtPassword.addPasswordToggle()
        let apple = UIImage(named: "apple_logo")
        btnSocialApple.configure(with: apple, title: "Continue with Apple")
        let facebook = UIImage(named: "fb_logo")
        btnSocialFacebook.configure(with: facebook, title: "Continue with Facebook")
        let google = UIImage(named: "google_logo")
        btnSocialGoogle.configure(with: google, title: "Continue with Google")
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func signUpAPI(email: String, password: String, phone: String) {
        self.eventHandler?(.loading)
        let requestModel = SignUpRequestModel(email: email, password: password, phone: phone)
        APIManager.shared.request(
            modelType: SignUpResponse.self,
            type: LogInSignUpEndPoint.signUp(requestModel: requestModel)) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    self.signupResponseData = response
                    DispatchQueue.main.async {
                        // SignUp successful
                        self.view.makeToast("\(response.message)", duration: 2.0, position: .center)
                        RSOTabBarViewController.presentAsRootController()
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                        // SignUp Unsuccessful
                        self.view.makeToast("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    @IBAction func btnSubmitTappedAction(_ sender: Any) {
        
        guard let email = txtEmail.text, !email.isEmpty else {
            self.view.makeToast("Please enter your email", duration: 2.0, position: .center)
            return
        }
        // Check if email is valid
        if !RSOValidator.isValidEmail(email) {
            self.view.makeToast("Invalid email", duration: 2.0, position: .center)
            return
        }
        guard let password = txtPassword.text, !password.isEmpty else {
            self.view.makeToast("Please enter your password", duration: 2.0, position: .center)
            return
        }
        // Check if password is valid
        if !RSOValidator.isValidPassword(password) {
            self.view.makeToast("The password must be more than 8 characters, at least 1 lower case, 1 upper case, 1 digit", duration: 2.0, position: .center)
            return
        }
        guard let phone = txtPhone.text, !phone.isEmpty else{
            self.view.makeToast("Please enter your phone",duration: 2.0,position: .center)
            return
        }
        // check if phone number is valid
        if !RSOValidator.validatePhoneNumber(phone){
            self.view.makeToast("Phone Number must contains at least 10 digits",duration: 2.0,position: .center)
            return
        }
       signUpAPI(email: email, password: password, phone: phone)
        
    }
}
extension SignUpViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
