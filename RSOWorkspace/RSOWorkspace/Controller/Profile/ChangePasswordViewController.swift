//
//  ChangePasswordViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 30/07/24.
//

import UIKit


class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var txtNewpassword: RSOTextField!
    @IBOutlet weak var txtConfirmPassword: RSOTextField!
    var eventHandler: ((_ event: Event) -> Void)?
    @IBOutlet weak var btnSubmit: RSOButton!
    var changePasswordResponseData: changePasswordResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        txtNewpassword.addPasswordToggle()
        txtConfirmPassword.addPasswordToggle()
        containerView.setCornerRadiusForView()
       
    }
    
    func chagnePasswordAPI(id :Int, new_password:String, confirm_password:String) {
      RSOLoader.showLoader()
        let requestModel = ChangePasswordRequestModel(id: id, confirm_password: confirm_password, new_password: new_password)
        print("requestModel",requestModel)
        APIManager.shared.request(
            modelType: changePasswordResponseModel.self,
            type: MyProfileEndPoint.changePassword(requestModel: requestModel)) { response in
                switch response {
                case .success(let response):
                    self.changePasswordResponseData = response
                    //record Updated successfully
                    DispatchQueue.main.async {
                      RSOLoader.removeLoader()
                        RSOToastView.shared.show("\(response.message ?? "")", duration: 2.0, position: .center)
                    }
                    self.clearFields()
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
    @IBAction func btnSubmitAction(_ sender: Any) {
        guard let newPassword = txtNewpassword.text, !newPassword.isEmpty else {
                    RSOToastView.shared.show("New password cannot be empty", duration: 2.0, position: .center)
                    return
                }
                
                guard let confirmPassword = txtConfirmPassword.text, !confirmPassword.isEmpty else {
                    RSOToastView.shared.show("Confirm password cannot be empty", duration: 2.0, position: .center)
                    return
                }
        if !RSOValidator.isValidPassword(confirmPassword) {
            RSOToastView.shared.show("The password must be more than 8 characters, at least 1 lower case, 1 upper case, 1 digit", duration: 2.0, position: .center)
            return
        }
                
                guard newPassword == confirmPassword else {
                    RSOToastView.shared.show("Passwords do not match", duration: 2.0, position: .center)
                    return
                }
        if !RSOValidator.isValidPassword(newPassword) {
            RSOToastView.shared.show("The password must be more than 8 characters, at least 1 lower case, 1 upper case, 1 digit", duration: 2.0, position: .center)
            return
        }
                
        guard let userId = UserHelper.shared.getUserId() else {
            return
        }
        self.chagnePasswordAPI(id: userId, new_password: newPassword, confirm_password: confirmPassword)
            }
            
            private func clearFields() {
                txtNewpassword.text = ""
                txtConfirmPassword.text = ""
            }
    
}
extension ChangePasswordViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}
