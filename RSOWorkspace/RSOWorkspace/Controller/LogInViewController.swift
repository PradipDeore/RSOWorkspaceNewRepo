//
//  LogInViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 12/02/24.
//

import UIKit
import Toast_Swift
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import AuthenticationServices

protocol LoginScreenActionDelegate: AnyObject {
  func loginScreenDismissed()
}
class CurrentLoginType {
  static let shared = CurrentLoginType()
  private init() {
    self.isExplorerLogin = false
  }
  var isExplorerLogin: Bool
  var explorerNavigationController: UINavigationController?
  weak var loginScreenDelegate:LoginScreenActionDelegate?
}
class LogInViewController: UIViewController {
    @IBOutlet weak var txtEmail: RSOTextField!
    @IBOutlet weak var txtPassword: RSOTextField!
    @IBOutlet weak var btnLogIn: RSOButton!
    @IBOutlet weak var btnSocialApple: RSOSocialButton!
    @IBOutlet weak var btnSocialFacebook: RSOSocialButton!
    @IBOutlet weak var btnSocialGoogle: RSOSocialButton!
    var fullName: String = ""
    var eventHandler: ((_ event: Event, _ message: String) -> Void)? // Data Binding Closure

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        btnSocialFacebook.addTarget(self, action: #selector(facebookLoginAction), for: .touchUpInside)
        btnSocialGoogle.addTarget(self, action: #selector(googleLoginAction), for: .touchUpInside)
        btnSocialApple.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func customizeUI(){
        txtEmail.placeholderText = "Your email"
        txtPassword.placeholderText = "Password"
        txtPassword.addPasswordToggle()
 
        txtPassword.addPasswordToggle()
        let apple = UIImage(named: "apple_logo")
        btnSocialApple.configure(with: apple, title: "Continue with Apple")
        let facebook = UIImage(named: "fb_logo")
        btnSocialFacebook.configure(with: facebook, title: "Continue with Facebook")
        let google = UIImage(named: "google_logo")
        btnSocialGoogle.configure(with: google, title: "Continue with Google")
    }
    
    // facebook
    @objc func facebookLoginAction() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] (result, error) in
            guard let self = self else { return }
            
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
                if let id = result["id"] as? String, let email = result["email"] as? String, let name = result["name"] as? String {
                    UserHelper.shared.saveSocialuser(name: name, email: email)
                    self.handleFacebookLoginSuccess(facebookId: id, email: email, name: name)
                }
            }
        }
    }
    
    func handleFacebookLoginSuccess(facebookId: String, email: String, name: String) {
        let requestModel = SocailLoginRequestModel(auth_type: "facebook", auth_id: facebookId, email: email, name: name)
        self.socialloginAPI(requestModel: requestModel)
    }
    //google
    @objc func googleLoginAction() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                // Handle the error appropriately here
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                // Handle the case where user or idToken is nil
                return
            }
            // Save user information for app-specific needs
            let name = user.profile?.name ?? "Unknown Name"
            let email = user.profile?.email ?? "Unknown Email"
            UserHelper.shared.saveSocialuser(name: name, email: email)
            // Create Google Auth credential
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // Pass the idToken as auth_id
            let requestModel = SocailLoginRequestModel(auth_type: "google", auth_id: user.accessToken.tokenString, email: email, name: name)
            self.socialloginAPI(requestModel: requestModel)
            
            // Sign in to Firebase with the Google credential
            Auth.auth().signIn(with: credential) { result, error in
                // Handle Firebase sign in result
                if let error = error {
                    // Handle error during Firebase sign in
                    print("Firebase sign-in error: \(error.localizedDescription)")
                    return
                }
                
            }
        }
        
    }
 
    //apple
    @objc func handleAppleIdRequest() {
           let appleIDProvider = ASAuthorizationAppleIDProvider()
           let request = appleIDProvider.createRequest()
           request.requestedScopes = [.fullName, .email]
           
           let authorizationController = ASAuthorizationController(authorizationRequests: [request])
           authorizationController.delegate = self
           authorizationController.presentationContextProvider = self
           authorizationController.performRequests()
       }

    
    private func handleAppleSignIn(userIdentifier: String, fullName: String?, email: String?, identityToken: String) {
        let name = fullName ?? ""
        let emailAddress = email ?? ""
        
        // Pass identityToken as auth_id
        let requestModel = SocailLoginRequestModel(auth_type: "apple", auth_id: userIdentifier, email: emailAddress, name: name)
        print("requestmodel for apple sign in ",requestModel)
        // Call the social login API with the updated request model
        socialloginAPI(requestModel: requestModel)
    }
    private func checkAppleIDCredentialState(userID: String) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userID) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                break
            case .revoked:
                // The Apple ID credential is revoked.
                break
            case .notFound:
                // No credential was found, so show the sign-in UI.
                break
            default:
                break
            }
        }
    }
    
    func socialloginAPI(requestModel:SocailLoginRequestModel) {
        RSOLoader.showLoader()
        // let requestModel = SocailLoginRequestModel(requestModel: requestModel)
        APIManager.shared.request(
            modelType: SocialLoginResponse.self,
            type: SocialLoginEndPoint.socialLogin(requestModel: requestModel)) { response in
                switch response {
                case .success(let response):
                    //save token in user defaults
                    if let token = response.token {
                        // Save data to user default
                        // -------------------  -------------------
                        RSOToken.shared.save(token: token)
                        UserHelper.shared.saveSocialLoginUser(true)
                        UserHelper.shared.saveSocialuser(name: requestModel.name, email: requestModel.email)
                        
                        // Fetch user details from response or use existing values
                        let nameFromResponse = response.name ?? ""
                        let emailFromResponse = response.email ?? ""
                        
//                        KeychainHelper.shared.saveUserToKeychain(token: token, email: requestModel.email, username: requestModel.name)
//                        
//                        let userIdentifier = KeychainHelper.shared.getUserFromKeychain().token
//                        let email = KeychainHelper.shared.getUserFromKeychain().email
//                        let fullName =  KeychainHelper.shared.getUserFromKeychain().username
                        // Check if the name and email are already stored in the Keychain
                      
                        let userIdentifier = KeychainHelper.shared.getUserFromKeychain().token
                        let storedName = KeychainHelper.shared.getUserFromKeychain().username ?? ""
                        let storedEmail = KeychainHelper.shared.getUserFromKeychain().email ?? ""
                                        
                        let finalName = !storedName.isEmpty ? storedName : nameFromResponse
                        let finalEmail = !storedEmail.isEmpty ? storedEmail : emailFromResponse
                                        
                        // Save the user details to the Keychain
                        KeychainHelper.shared.saveUserToKeychain(token: token, email: finalEmail, username: finalName)
                                        
                        print("saved successfully in key chain")
                        print("User id is \(userIdentifier) \n Full Name is \(String(describing: finalName)) \n Email id is \(String(describing: finalEmail))")
                        
                        
                        DispatchQueue.main.async {
                            RSOLoader.removeLoader()
                            // Login successful
                            
                            RSOToastView.shared.show("Login successful!", duration: 2.0, position: .center)
                            if CurrentLoginType.shared.isExplorerLogin {
                                CurrentLoginType.shared.isExplorerLogin = false
                                CurrentLoginType.shared.loginScreenDelegate?.loginScreenDismissed()
                                CurrentLoginType.shared.explorerNavigationController?.dismiss(animated: true)
                            } else {
                                RSOTabBarViewController.presentAsRootController()
                            }
                        }
                        self.eventHandler?(.dataLoaded, "Login Successfull")
                    }else{
                        DispatchQueue.main.async {
                            RSOLoader.removeLoader()
                            // Login successful
                            RSOToastView.shared.show(response.message ?? "LogIn Failed!", duration: 2.0, position: .center)
                        }
                    }
                case .failure(let error):
                    self.eventHandler?(.error(error), "Login failed!")
                    DispatchQueue.main.async {
                        RSOLoader.removeLoader()
                        // Login successful
                        RSOToastView.shared.show("Login failed!", duration: 2.0, position: .center)
                    }
                }
            }
    }
    

  func loginAPI(email: String, password: String) {
    RSOLoader.showLoader()
    let requestModel = LoginRequestModel(email: email, password: password)
    APIManager.shared.request(
      modelType: LogInSuccessResponse.self,
      type: LogInSignUpEndPoint.logIn(requestModel: requestModel)) { response in
        switch response {
        case .success(let response):
          //save token in user defaults
          if let token = response.token, let user = response.data {
            // Save data to user default
            // -------------------  -------------------
            RSOToken.shared.save(token: token)
            UserHelper.shared.saveUser(user)
            UserHelper.shared.saveUserIsGuest(response.isGuest ?? false)
              
            CardListManager.shared.getCardDetails()
              
            // -------------------  -------------------
            DispatchQueue.main.async {
              RSOLoader.removeLoader()
              // Login successful
              RSOToastView.shared.show("Login successful!", duration: 2.0, position: .center)
              if CurrentLoginType.shared.isExplorerLogin {
                  CurrentLoginType.shared.isExplorerLogin = false
                CurrentLoginType.shared.loginScreenDelegate?.loginScreenDismissed()
                CurrentLoginType.shared.explorerNavigationController?.dismiss(animated: true)
              } else {
                RSOTabBarViewController.presentAsRootController()
              }
            }
             // self.eventHandler?(.dataLoaded, nil)
          }else{
            DispatchQueue.main.async {
              RSOLoader.removeLoader()
              // Login successful
              RSOToastView.shared.show(response.message ?? "LogIn Failed!", duration: 2.0, position: .center)
            }
          }
        case .failure(let error):
          //self.eventHandler?(.error(error))
          DispatchQueue.main.async {
            RSOLoader.removeLoader()
            // Login successful
            RSOToastView.shared.show("Login failed!", duration: 2.0, position: .center)
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
        
         //Check if password is valid
//        if !RSOValidator.isValidPassword(password) {
//            RSOToastView.shared.show("The password must be more than 8 characters, at least 1 lower case, 1 upper case, 1 digit", duration: 2.0, position: .center)
//            return
//        }
        loginAPI(email: email, password: password)

        
    }
    @IBAction func btnSignUpTappedAction(_ sender: Any) {
        let signUpVC = UIViewController.createController(storyBoard: .GetStarted, ofType: SignUpViewController.self)
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
  class func showLoginViewController() {
    CurrentLoginType.shared.isExplorerLogin = true
      // Create your RSOTabBarVC instance
     let logInViewController = UIViewController.createController(storyBoard: .GetStarted, ofType:  LogInViewController.self)
    CurrentLoginType.shared.explorerNavigationController = UINavigationController(rootViewController: logInViewController)
    UIApplication.shared.topViewController?.present(CurrentLoginType.shared.explorerNavigationController!, animated: true)
  }

}
extension LogInViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}

extension LogInViewController:ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            
            if let nameComponents = appleIDCredential.fullName {
                var nameParts: [String] = []
                
                if let givenName = nameComponents.givenName {
                    nameParts.append(givenName)
                }
                
                if let familyName = nameComponents.familyName {
                    nameParts.append(familyName)
                }
                
                fullName = nameParts.joined(separator: " ") // Combine given and family name
            }
            
            if fullName.isEmpty {
                fullName = KeychainHelper.shared.getUserFromKeychain().username ?? ""
            }
            
            let email = appleIDCredential.email ?? KeychainHelper.shared.getUserFromKeychain().email
            let identityToken = appleIDCredential.identityToken
            
            print("saveSocialLoginUser --> User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            
            UserHelper.shared.saveSocialLoginUser(true)
            if let tokenData = identityToken, let tokenString = String(data: tokenData, encoding: .utf8) {
                handleAppleSignIn(userIdentifier: userIdentifier, fullName: fullName, email: email, identityToken: tokenString)
            } else {
                print("Failed to convert identity token to string")
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle the error appropriately here
        print("Sign in with Apple failed: \(error.localizedDescription)")
        RSOToastView.shared.show("Sign in with Apple failed. Please try again.", duration: 2.0, position: .center)
    }
}

extension LogInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
