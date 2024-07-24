//
//  LogInViewController2.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/02/24.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var txtEmail: RSOTextField!
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    var otpResponse: ForgotPasswordResponse?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
       
    }
    func customizeUI(){
        txtEmail.placeholderText = "Your email"
        txtEmail.placeholderFont = RSOFont.inter(size: 16, type: .Medium)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnCheckVerifyScreenAction(_ sender: Any) {
        let verifyVC = UIViewController.createController(storyBoard: .GetStarted, ofType: VerifyViewController.self)
        self.navigationController?.pushViewController(verifyVC, animated: true)
    }
    
    func forgotPasswordAPI(email: String) {
        let requestModel = ForgotPasswordRequestModel(email: email)
        APIManager.shared.request(
            modelType: ForgotPasswordResponse.self,
            type: LogInSignUpEndPoint.forgotPassword(requestModel: requestModel)) { response in
                switch response {
                case .success(let response):
                    self.otpResponse = response
                    //save token in user defaults
                    DispatchQueue.main.async {
                        // Login successful
                        RSOToastView.shared.show("\(response.message)", duration: 2.0, position: .center)
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                        // Login successful
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
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
        forgotPasswordAPI(email:email)
        
    }
}
extension ForgotPasswordViewController {
    enum Event {
        
        case dataLoaded
        case error(Error?)
    }
}
