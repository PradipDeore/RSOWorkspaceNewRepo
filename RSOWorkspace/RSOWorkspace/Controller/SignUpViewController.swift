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
    @IBOutlet weak var btnSocialApple: RSOSocialButton!
    @IBOutlet weak var btnSocialFacebook: RSOSocialButton!
    @IBOutlet weak var btnSocialGoogle: RSOSocialButton!
    
    var eventHandler: ((_ event: Event, _ message: String) -> Void)? // Data Binding Closure
    var signupResponseData: SignUpResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addEventHandler()
        self.customizeUI()
        //        btnSocialFacebook.addTarget(self, action: #selector(facebookLoginAction), for: .touchUpInside)
        //        btnSocialGoogle.addTarget(self, action: #selector(googleLoginAction), for: .touchUpInside)
        //        btnSocialApple.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        //
        
    }
    func customizeUI(){
        txtEmail.placeholderText = "Your email"
        txtPassword.placeholderText = "Password"
        txtPhone.placeholderText = "Your phone number"
        txtPassword.addPasswordToggle()
        //        let apple = UIImage(named: "apple_logo")
        //        btnSocialApple.configure(with: apple, title: "Continue with Apple")
        //        let facebook = UIImage(named: "fb_logo")
        //        btnSocialFacebook.configure(with: facebook, title: "Continue with Facebook")
        //        let google = UIImage(named: "google_logo")
        //        btnSocialGoogle.configure(with: google, title: "Continue with Google")
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // facebook
    //    @objc func facebookLoginAction() {
    //        let loginManager = LoginManager()
    //        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] (result, error) in
    //            guard let self = self else { return }
    //
    //            if let error = error {
    //                print("Failed to login: \(error.localizedDescription)")
    //                return
    //            }
    //
    //            guard let result = result, !result.isCancelled else {
    //                print("User cancelled login")
    //                return
    //            }
    //
    //            self.fetchFacebookUserProfile()
    //        }
    //    }
    //
    //    func fetchFacebookUserProfile() {
    //        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])
    //        request.start { _, result, error in
    //            if let error = error {
    //                print("Failed to fetch user profile: \(error.localizedDescription)")
    //                return
    //            }
    //
    //            if let result = result as? [String: Any] {
    //                print("User profile: \(result)")
    //                if let id = result["id"] as? String, let email = result["email"] as? String, let name = result["name"] as? String {
    //                    UserHelper.shared.saveSocialuser(name: name, email: email)
    //                    self.handleFacebookLoginSuccess(facebookId: id, email: email, name: name)
    //                }
    //            }
    //        }
    //    }
    
    //    func handleFacebookLoginSuccess(facebookId: String, email: String, name: String) {
    //        let requestModel = SocailLoginRequestModel(auth_type: "facebook", auth_id: facebookId, email: email, name: name)
    //        self.socialloginAPI(requestModel: requestModel)
    //    }
    //    //google
    //    @objc func googleLoginAction() {
    //        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
    //
    //        // Create Google Sign In configuration object.
    //        let config = GIDConfiguration(clientID: clientID)
    //        GIDSignIn.sharedInstance.configuration = config
    //
    //        // Start the sign in flow!
    //        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
    //            guard error == nil else {
    //                // Handle the error appropriately here
    //                return
    //            }
    //
    //            guard let user = result?.user,
    //                  let idToken = user.idToken?.tokenString
    //            else {
    //                // Handle the case where user or idToken is nil
    //                return
    //            }
    //            // Save user information for app-specific needs
    //            let name = user.profile?.name ?? "Unknown Name"
    //            let email = user.profile?.email ?? "Unknown Email"
    //            UserHelper.shared.saveSocialuser(name: name, email: email)
    //            // Create Google Auth credential
    //            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
    //                                                           accessToken: user.accessToken.tokenString)
    //
    //            // Pass the idToken as auth_id
    //            let requestModel = SocailLoginRequestModel(auth_type: "google", auth_id: idToken, email: email, name: name)
    //            self.socialloginAPI(requestModel: requestModel)
    //
    //            // Sign in to Firebase with the Google credential
    //            Auth.auth().signIn(with: credential) { result, error in
    //                // Handle Firebase sign in result
    //                if let error = error {
    //                    // Handle error during Firebase sign in
    //                    print("Firebase sign-in error: \(error.localizedDescription)")
    //                    return
    //                }
    //
    //            }
    //        }
    //
    //    }
    
    func addEventHandler() {
        self.eventHandler = { [weak self] (event, message) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch event {
                case .dataLoaded:
                    RSOToastView.shared.show("\(message)", duration: 2.0, position: .center)
                    // Check the status of the response before popping the view controller
                    if let signupResponse = self.signupResponseData, signupResponse.status {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.navigationController?.popViewController(animated: true)
                            // RSOTabBarViewController.presentAsRootController()
                        }
                    }
                    
                case .error(_):
                    RSOToastView.shared.show("\(message)", duration: 2.0, position: .center)
                }
            }
        }
    }
    
    
    //apple
    //    @objc func handleAppleIdRequest() {
    //        let appleIDProvider = ASAuthorizationAppleIDProvider()
    //        let request = appleIDProvider.createRequest()
    //        request.requestedScopes = [.fullName, .email]
    //        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    //        authorizationController.delegate = self
    //        authorizationController.performRequests()
    //    }
    //
    //    private func handleAppleSignIn(userIdentifier: String, fullName: PersonNameComponents?, email: String?) {
    //        // Convert `fullName` to a string or use directly if needed
    //        let name = fullName?.givenName ?? ""
    //
    //        // Use the provided email if available, or handle the case where it might be nil
    //        let emailAddress = email ?? ""
    //
    //        // Create a model to send to your backend or perform additional actions
    //        let requestModel = SocailLoginRequestModel(auth_type: "apple", auth_id: userIdentifier, email: emailAddress, name: name)
    //
    //        // Call the social login API
    //        socialloginAPI(requestModel: requestModel)
    //    }
    //    private func checkAppleIDCredentialState(userID: String) {
    //        let appleIDProvider = ASAuthorizationAppleIDProvider()
    //        appleIDProvider.getCredentialState(forUserID: userID) { (credentialState, error) in
    //            switch credentialState {
    //            case .authorized:
    //                // The Apple ID credential is valid.
    //                break
    //            case .revoked:
    //                // The Apple ID credential is revoked.
    //                break
    //            case .notFound:
    //                // No credential was found, so show the sign-in UI.
    //                break
    //            default:
    //                break
    //            }
    //        }
    //    }
    
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
    //    func socialloginAPI(requestModel:SocailLoginRequestModel) {
    //        RSOLoader.showLoader()
    //        // let requestModel = SocailLoginRequestModel(requestModel: requestModel)
    //        APIManager.shared.request(
    //            modelType: SocialLoginResponse.self,
    //            type: SocialLoginEndPoint.socialLogin(requestModel: requestModel)) { response in
    //                switch response {
    //                case .success(let response):
    //                    //save token in user defaults
    //                    if let token = response.token {
    //                        // Save data to user default
    //                        // -------------------  -------------------
    //                        RSOToken.shared.save(token: token)
    //                        UserHelper.shared.saveSocialLoginUser(true)
    //                        UserHelper.shared.saveSocialuser(name: requestModel.name, email: requestModel.email)
    //                        // Check if the user was a guest before the social login
    ////                        if UserHelper.shared.isGuest() || UserHelper.shared.isUserExplorer() {
    ////                            // Save user as guest using social login details
    ////                            UserHelper.shared.saveSocialuser(name: requestModel.name, email: requestModel.email)
    ////                            UserHelper.shared.saveUserIsGuest(true) // Set guest flag to true
    ////                        } else {
    ////                            // Save user as a regular logged-in user
    ////                            UserHelper.shared.saveSocialuser(name: requestModel.name, email: requestModel.email)
    ////                            UserHelper.shared.saveUserIsGuest(false) // Set guest flag to false
    ////                        }
    //                        // -------------------  -------------------
    //                        DispatchQueue.main.async {
    //                            RSOLoader.removeLoader()
    //                            // Login successful
    //
    //                            RSOToastView.shared.show("Login successful!", duration: 2.0, position: .center)
    //
    //                        }
    //                        self.eventHandler?(.dataLoaded, "data loaded" )
    //                    }else{
    //                        DispatchQueue.main.async {
    //                            RSOLoader.removeLoader()
    //                            // Login successful
    //                            RSOToastView.shared.show(response.message ?? "LogIn Failed!", duration: 2.0, position: .center)
    //                        }
    //                    }
    //                case .failure(let error):
    //                    self.eventHandler?(.error(error), error.localizedDescription)
    //                    DispatchQueue.main.async {
    //                        RSOLoader.removeLoader()
    //                        // Login successful
    //                        RSOToastView.shared.show("Login failed!", duration: 2.0, position: .center)
    //                    }
    //                }
    //            }
    //    }
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
//extension SignUpViewController:ASAuthorizationControllerDelegate {
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
//            UserHelper.shared.saveSocialuser(name: userIdentifier, email: email ?? "")
//            handleAppleSignIn(userIdentifier: userIdentifier, fullName: fullName, email: email)
//        }
//
//    }
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        // Handle the error appropriately here
//        print("Sign in with Apple failed: \(error.localizedDescription)")
//        RSOToastView.shared.show("Sign in with Apple failed. Please try again.", duration: 2.0, position: .center)
//    }
//}
//


