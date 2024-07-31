//
//  YourDetailsViewController.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 25/07/24.
//

import UIKit

class YourDetailsViewController: UIViewController, MembershipNavigable {
  var membershipNavigationDelegate: MembershipNavigationDelegate?
  @IBOutlet var yourDetailsView: UIView!
  @IBOutlet var loggedinView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
      yourDetailsView.isHidden = false
      loggedinView.isHidden = true
      CurrentLoginType.shared.loginScreenDelegate = self
        // Do any additional setup after loading the view.
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  @IBAction func createAccountAction(_ sender: Any) {
    LogInViewController.showLoginViewController()
  }
  @IBAction func loginNowAction(_ sender: Any) {
    LogInViewController.showLoginViewController()
  }
  @IBAction func continueAction(_ sender: Any) {
    membershipNavigationDelegate?.navigateToNextVC()
  }
}
extension YourDetailsViewController: LoginScreenActionDelegate {
  func loginScreenDismissed() {
    DispatchQueue.main.async {
      if !UserHelper.shared.isUserExplorer() {
        self.yourDetailsView.isHidden = true
        self.loggedinView.isHidden = false
      }
    }
  }
}
