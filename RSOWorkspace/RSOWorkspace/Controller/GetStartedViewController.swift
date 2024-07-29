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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the back button
           navigationItem.hidesBackButton = true
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

        RSOTabBarViewController.presentAsRootController()
    }
    
    
    class func presentAsRootController() {
        // Create your RSOTabBarVC instance
       let getStartedVC = UIViewController.createController(storyBoard: .GetStarted, ofType:  GetStartedViewController.self)
        // Set the navigation controller as the root view controller of the window
        AppDelegate.setWindowRoot(viewController: getStartedVC)

    }
}
