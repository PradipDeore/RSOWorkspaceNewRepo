//
//  LogInVC.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 09/02/24.
//

import UIKit
import Toast_Swift
class GetStartedViewController: UIViewController {

    @IBOutlet weak var imgBackground1: UIImageView!
    var eventHandler: ((_ event: Event) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the back button
           navigationItem.hidesBackButton = true
    }
    func exporeloginAPI(email: String) {
      RSOLoader.showLoader()
      let requestModel = exploreRequest(email: email)
      APIManager.shared.request(
        modelType: ExploreResponse.self,
        type: ExploreButtonEndPoint.exploreLogin(requestModel: requestModel)) { response in
          switch response {
          case .success(let response):
            //save token in user defaults
              if let token = response.token{
              // Save data to user default
              // -------------------  -------------------
                RSOToken.shared.save(token: token)
             
              // -------------------  -------------------
              DispatchQueue.main.async {
                RSOLoader.removeLoader()
                // Login successful
                CurrentLoginType.shared.isExplorerLogin = true
                RSOTabBarViewController.presentAsRootController()
              }
              self.eventHandler?(.dataLoaded)
            }else{
              DispatchQueue.main.async {
                RSOLoader.removeLoader()
              }
            }
          case .failure(let error):
            self.eventHandler?(.error(error))
            DispatchQueue.main.async {
              RSOLoader.removeLoader()
              // Login successful
              RSOToastView.shared.show("Login failed!", duration: 2.0, position: .center)
            }
          }
        }
    }
    @IBAction func btnLogInTappedAction(_ sender: Any) {

        let logInVC = UIViewController.createController(storyBoard: .GetStarted, ofType: LogInViewController.self)
        self.navigationController?.pushViewController(logInVC, animated: true)
        
    }
    
    @IBAction func btnSignUpTappedAction(_ sender: Any) {
        let signUpVC = UIViewController.createController(storyBoard: .GetStarted, ofType: SignUpViewController.self)
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func btnExploreTappedAction(_ sender: Any) {
        exporeloginAPI(email: "bharati.d@aquilmedia.in")
    }
    
    class func presentAsRootController() {
        // Create your RSOTabBarVC instance
       let getStartedVC = UIViewController.createController(storyBoard: .GetStarted, ofType:  GetStartedViewController.self)
        // Set the navigation controller as the root view controller of the window
        AppDelegate.setWindowRoot(viewController: getStartedVC)

    }
}

extension GetStartedViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}
