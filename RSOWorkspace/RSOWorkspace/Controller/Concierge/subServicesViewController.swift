//
//  subServicesViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 19/03/24.
//

import UIKit
import Kingfisher
class subServicesViewController: UIViewController {
    
    var coordinator: RSOTabBarCordinator?
    
    @IBOutlet weak var lblSubService: UILabel!
    @IBOutlet weak var imgService: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dropdownServiceView: UIView!
    @IBOutlet weak var provideDetailsView: UIView!
    
    @IBOutlet weak var txtProvideDetailsTextView: UITextView!
    @IBOutlet weak var requestButtonView: UIView!
    @IBOutlet weak var txtSubServices: UITextField!
    @IBOutlet weak var btnRequest: RSOButton!
    @IBOutlet weak var dropdownButton: UIButton!
    
    var dropdownOptions: [SubService] = [] // Add dropdownOptions property
    var eventHandler: ((_ event: Event) -> Void)?
    var service: Service?
    var cornerRadius: CGFloat = 10.0
    var serviceId = 0
    var subServiceId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator?.hideBackButton(isHidden:false)
        coordinator?.setTitle(title: "Concierge")
        
        customizeCell()
        setData()
    }
    func customizeCell() {
        
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        self.containerView.addShadow()
        self.dropdownServiceView.isHidden = false
        self.dropdownServiceView.setCornerRadiusForView()
        self.provideDetailsView.setCornerRadiusForView()
        self.txtProvideDetailsTextView.addPlaceholder(text: "Please provide your details about issue")
        self.txtSubServices.setUpTextFieldView(rightImageName: "arrowdown")
        self.btnRequest.layer.cornerRadius = btnRequest.bounds.height / 2
        
    }
    
    func setData(){
        self.lblSubService.text = service?.title
        if let imageUrl = service?.image, !imageUrl.isEmpty{
            let url = URL(string: imageBasePath + imageUrl)
            self.imgService.kf.setImage(with: url)
        }
        self.dropdownOptions = service?.subServices ?? []
        //service?.subServices.removeAll() // set response aray empty
        if let subServices = service?.subServices, subServices.isEmpty{
            self.dropdownServiceView.isHidden = true
            
        }else{
            self.dropdownServiceView.isHidden = false
        }
    }
    
    @IBAction func dropdownButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Services", message: nil, preferredStyle: .actionSheet)
        
        for option in dropdownOptions {
            let action = UIAlertAction(title: option.title, style: .default) { [weak self] _ in
                print("Selected option: \(option.title)")
                self?.txtSubServices.text = option.title
                self?.serviceId = option.id
                
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    private func areFieldsValid() -> Bool {
        
        guard let subServiceText = txtSubServices.text, !subServiceText.isEmpty else {
            RSOToastView.shared.show("Please select a sub-service", duration: 2.0, position: .center)
            return false
        }
        guard let detailsText = txtProvideDetailsTextView.text, !detailsText.isEmpty else {
            RSOToastView.shared.show("Please provide details about the issue", duration: 2.0, position: .center)
            return false
        }
        guard let member_id = UserHelper.shared.getUserId() else {
            return false
        }
        subServicesAPI(service_id: serviceId, description: detailsText, sub_service_id: subServiceId, member_id: member_id)
        
        return true
        
    }
    @IBAction func btnRequestActionTapped(_ sender: Any) {
        
        guard areFieldsValid() else {
            return
        }
        
    }
    func subServicesAPI(service_id :Int,description:String,sub_service_id:Int,member_id:Int) {
        let requestModel = subServicesRequestModel(service_id: service_id, sub_service_id: sub_service_id, description: description, member_id: member_id)
        print("requestModel",requestModel)
        APIManager.shared.request(
            modelType: ReportAnIssueResponse.self,
            type: ServicesEndPoint.subServices(requestModel: requestModel)) { response in
                switch response {
                case .success(let response):
                    //record inserted successfully
                    DispatchQueue.main.async {
                        RSOToastView.shared.show("\(response.message)", duration: 3.0, position: .center)
                        // Reset the form
                        self.resetForm()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                        //  Unsuccessful
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    private func resetForm() {
            self.txtSubServices.text = ""
            self.txtProvideDetailsTextView.text = ""
            self.serviceId = 0
        }
}

extension subServicesViewController {
    enum Event {
        
        case dataLoaded
        case error(Error?)
    }
}




