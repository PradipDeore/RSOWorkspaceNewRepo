//
//  LogInViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 12/02/24.
//

import UIKit
import Toast_Swift
class LogInViewController: UIViewController {
    @IBOutlet weak var txtEmail: RSOTextField!
    @IBOutlet weak var txtPassword: RSOTextField!
    @IBOutlet weak var btnLogIn: RSOButton!
    
    var userlogInDataSuccess: LogInSuccessResponse?
    var userLoginFailed:LogInErrorResponse?
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
    }
    func customizeUI(){
        txtEmail.placeholderText = "Your email"
        txtPassword.placeholderText = "Password"
        txtPassword.addPasswordToggle()
    }
    
    func loginAPI(email: String, password: String) {
        self.eventHandler?(.loading)
        let requestModel = LoginRequestModel(email: email, password: password)
        APIManager.shared.request(
            modelType: LogInSuccessResponse.self,
            type: LogInSignUpEndPoint.logIn(requestModel: requestModel)) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let response):
                    self.userlogInDataSuccess = response
                    //save token in user defaults
                    if let token = response.token{
                        RSOToken.shared.save(token: token)
                        
                        DispatchQueue.main.async {
                            // Login successful
                            self.view.makeToast("Login successful!", duration: 2.0, position: .center)
                            RSOTabBarViewController.presentAsRootController()
                        }
                        self.eventHandler?(.dataLoaded)
                    }else{
                        DispatchQueue.main.async {
                            // Login successful
                            self.view.makeToast(response.message ?? "LogIn Failed!", duration: 2.0, position: .center)
                        }
                    }
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                        // Login successful
                        self.view.makeToast("Login failed!", duration: 2.0, position: .center)
                    }
                }
            }
    }
    @IBAction func btnForgotPassTappedAction(_ sender: Any) {
        
        let forgotPassVC = UIViewController.createController(storyBoard: .GetStarted, ofType: ForgotPasswordViewController.self)
        self.navigationController?.pushViewController(forgotPassVC, animated: true)
    }
    
    @IBAction func btnLogInTappedAction(_ sender: Any) {
       
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
        /*if !RSOValidator.isValidPassword(password) {
            self.view.makeToast("The password must be more than 8 characters, at least 1 lower case, 1 upper case, 1 digit", duration: 2.0, position: .center)
            return
        }*/
        loginAPI(email: email, password: password)

        
    }
    @IBAction func btnSignUpTappedAction(_ sender: Any) {
        let signUpVC = UIViewController.createController(storyBoard: .GetStarted, ofType: SignUpViewController.self)
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
  
}
extension LogInViewController {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
