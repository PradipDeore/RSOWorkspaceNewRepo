//
//  PaymentSuccessViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/10/24.
//

import UIKit

class PaymentSuccessViewController: UIViewController {

    @IBOutlet weak var paymentSuccessView: UIView!
    
    @IBOutlet weak var btnDismissView: UIButton!
    @IBOutlet weak var btnHome: RSOButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentSuccessView.setCornerRadiusForView()
        btnHome.backgroundColor = ._768_D_70
    }
    

    @IBAction func btnGoToHomepageAction(_ sender: Any) {
        dismiss(animated: true)
        RSOTabBarViewController.presentAsRootController()
    }
    
    @IBAction func btnDismissViewAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
