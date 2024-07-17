//
//  FeedbackViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/04/24.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var imgEmojies: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imgEmojies.setRounded()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnSubmitActionTapped(_ sender: Any) {
    }
    

}
