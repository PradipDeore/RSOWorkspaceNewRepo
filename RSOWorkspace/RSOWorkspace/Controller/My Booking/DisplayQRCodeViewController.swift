//
//  DisplayQRCodeViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 26/07/24.
//

import UIKit

class DisplayQRCodeViewController: UIViewController {

    @IBOutlet weak var QRCodeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        QRCodeView.setCornerRadiusForView()
    }

    @IBAction func btnHideViewTappedAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
