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
  
  var eventHandler: ((_ event: Event, _ message: String) -> Void)? // Data Binding Closure
  var signupResponseData: SignUpResponse?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.addEventHandler()
    self.customizeUI()
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
    case dataLoaded
    case error(Error?)
  }
}
