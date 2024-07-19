//
//  UpdateProfileViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 11/04/24.
//

import UIKit
import Toast_Swift

class UpdateProfileViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    weak var dismissDelegate: SubViewDismissalProtocol?
    @IBOutlet weak var txtFirstName: RSOTextField!
    @IBOutlet weak var txtLastname: RSOTextField!
    @IBOutlet weak var txtDesignation: RSOTextField!
   
    var firstName = ""
    var lastName = ""
    var designation = ""
    
    @IBOutlet weak var btnUpdate: RSOButton!
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    
    var updateProfileResponseData: UpdateProfileResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setValuesforTextFileds()
        customizeCell()
    }
    
    func setValuesforTextFileds(){
       
        print("Setting values for text fields")
        print("firstName:", firstName)
        print("lastName:", lastName)
        print("designation:", designation)
        
        txtFirstName.text = firstName
        txtLastname.text = lastName
        txtDesignation.text = designation
        
        txtFirstName.placeholderFont = RSOFont.inter(size: 16, type: .Medium)
        txtFirstName.customBorderWidth = 0.0
        
        txtLastname.placeholderFont = RSOFont.inter(size: 16, type: .Medium)
        txtLastname.customBorderWidth = 0.0
        
        txtDesignation.placeholderFont = RSOFont.inter(size: 16, type: .Medium)
        txtDesignation.customBorderWidth = 0.0
    }
    
    func updateProfileAPI(fname :String?, lname:String?, designation:String?) {
      RSOLoader.showLoader()
        let requestModel = UpdateProfileRequestModel(first_name: fname, last_name: lname, designation: designation)
        print("requestModel",requestModel)
        APIManager.shared.request(
            modelType: UpdateProfileResponse.self,
            type: MyProfileEndPoint.updateProfile(requestModel: requestModel)) { response in
                
                switch response {
                case .success(let response):
                    
                    self.updateProfileResponseData = response
                  UserHelper.shared.saveUserFirstName(firstName: fname)
                  UserHelper.shared.saveUserLastName(lastName: lname)
                  UserHelper.shared.saveUserDesignation(designation: designation)
                    //record Updated successfully
                    DispatchQueue.main.async {
                      RSOLoader.removeLoader()
                        self.dismissDelegate?.subviewDismmised()
                        RSOToastView.shared.show("\(response.message)", duration: 2.0, position: .center)
                    }
                    
                    // Pause execution for 5 seconds using DispatchQueue
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.dismiss(animated: true, completion: nil)
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                      RSOLoader.removeLoader()
                        //  Unsuccessful
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    
    func customizeCell(){
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        
        let shadowColor = UIColor.black.withAlphaComponent(0.5)
        self.containerView.layer.shadowColor = shadowColor.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.containerView.layer.shadowRadius = 10.0
        self.containerView.layer.shadowOpacity = 19.0
        self.containerView.layer.masksToBounds = false
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect:  CGRect(x: 0, y: self.containerView.bounds.height - 4, width: self.containerView.bounds.width, height: 4), cornerRadius: self.containerView.layer.cornerRadius).cgPath
    }
    
    @IBAction func btnDismissView(_ sender: Any) {
        dismiss(animated: true)

    }

    @IBAction func btnUpdateAction(_ sender: Any) {
        let fname = txtFirstName.text
        let lname = txtLastname.text
        let designation = txtDesignation.text
        updateProfileAPI(fname: fname, lname: lname, designation: designation)

    }
}
extension UpdateProfileViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}
