//
//  SignUpViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/02/24.
//

import UIKit
import FBSDKLoginKit

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var txtEmail: RSOTextField!
  @IBOutlet weak var txtPassword: RSOTextField!
  @IBOutlet weak var txtPhone: RSOTextField!
  @IBOutlet weak var btnSocialApple: RSOSocialButton!
  @IBOutlet weak var btnSocialFacebook: RSOSocialButton!
  @IBOutlet weak var btnSocialGoogle: RSOSocialButton!
  
  var eventHandler: ((_ event: Event, _ message: String) -> Void)? // Data Binding Closure
  var signupResponseData: SignUpResponse?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.addEventHandler()
    self.customizeUI()
      btnSocialFacebook.addTarget(self, action: #selector(facebookLoginAction), for: .touchUpInside)

      
  }
    @objc func facebookLoginAction() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }
            
            self.fetchFacebookUserProfile()
        }
    }

    func fetchFacebookUserProfile() {
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])
        request.start { _, result, error in
            if let error = error {
                print("Failed to fetch user profile: \(error.localizedDescription)")
                return
            }
            
            if let result = result as? [String: Any] {
                print("User profile: \(result)")
                if let email = result["email"] as? String, let name = result["name"] as? String {
                    self.handleFacebookLoginSuccess(email: email, name: name)
                }
            }
        }
    }

    func handleFacebookLoginSuccess(email: String, name: String) {
        // Handle the Facebook login success, e.g., navigate to another screen or call your signup API
        print("Successfully logged in with email: \(email), name: \(name)")
        // You can call your signUpAPI method here or handle user navigation
    }

  func addEventHandler() {
    self.eventHandler = { [weak self] (event, message) in
      guard let self = self else { return }
      DispatchQueue.main.async {
        switch event {
        case .dataLoaded:
          RSOToastView.shared.show("\(message)", duration: 2.0, position: .center)
          DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.navigationController?.popViewController(animated: true)
          }
        case .error(_):
          RSOToastView.shared.show("\(message)", duration: 2.0, position: .center)
        }
      }
    }
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
    let requestModel = SignUpRequestModel(email: email, password: password, phone: phone)
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
    if !RSOValidator.validatePhoneNumber(phone){
      RSOToastView.shared.show("Phone Number must contains at least 10 digits",duration: 2.0,position: .center)
      return
    }
    signUpAPI(email: email, password: password, phone: phone)
    
  }
}
extension SignUpViewController {
  enum Event {
    case dataLoaded
    case error(Error?)
  }
}
