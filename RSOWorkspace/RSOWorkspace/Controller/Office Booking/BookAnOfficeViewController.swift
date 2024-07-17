//
//  BookAnOfficeViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 29/03/24.
//

import UIKit

class BookAnOfficeViewController: UIViewController {

    var coordinator: RSOTabBarCordinator?
     @IBOutlet weak var txtName: RSOTextField!
       @IBOutlet weak var txtEmail: UITextField!
       @IBOutlet weak var txtPhone: UITextField!
       @IBOutlet weak var btnInterestedIn: UIButton!
       @IBOutlet weak var txtInterestedIn: UITextField!
       @IBOutlet weak var txtNoOfSeats: UITextField!
       @IBOutlet weak var btnMinus: RSOButton!
       @IBOutlet weak var btnPlus: RSOButton!
       @IBOutlet weak var txtprovideDetails: UITextView!
       @IBOutlet weak var btnSubmit: RSOButton!
   
    @IBOutlet weak var provideDetailsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        coordinator?.hideBackButton(isHidden:false)
        coordinator?.setTitle(title: "Book an Office")
       
        setButtonsANDTextFields()
      
    }
    func setButtonsANDTextFields(){
        self.btnMinus.layer.cornerRadius = btnMinus.bounds.height / 2
        self.btnPlus.layer.cornerRadius = btnPlus.bounds.height / 2
        txtprovideDetails.addPlaceholder(text: "Please provide any details")
        txtInterestedIn.setUpTextFieldView(rightImageName:"arrowdown")
        provideDetailsView.setCornerRadiusForView()
        
    }
    
    @IBAction func btnSubmitTappedAction(_ sender: Any) {
    }
    

}
