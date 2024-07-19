//
//  FeedbackViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/04/24.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var imgEmojies: UIImageView!
    
    @IBOutlet weak var provideDetailsTextView: UITextView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        provideDetailsTextView.addPlaceholder(text: "Please provide any details")
        self.imgEmojies.setRounded()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnSubmitActionTapped(_ sender: Any) {
    }
    

}
