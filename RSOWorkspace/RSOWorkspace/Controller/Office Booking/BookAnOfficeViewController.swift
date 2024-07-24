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
    var eventHandler: ((_ event: Event) -> Void)?
    var officeBookingResonseData:BookOffice?
    
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
    func bookOffice(requestModel: BookOfficeRequestModel) {
        
        APIManager.shared.request(
            modelType: OfficeBookingResponseModel.self,
            type: MyBookingEndPoint.officeBooking(requestModel: requestModel)) { [weak self] response in
                
                guard let self = self else { return }                
                switch response {
                case .success(let responseData):
                    // Handle successful response with bookings
                    self.officeBookingResonseData = responseData.data
                    DispatchQueue.main.async {
                        RSOToastView.shared.show("Booking Saved For Office", duration: 2.0, position: .center)
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    @IBAction func btnSubmitTappedAction(_ sender: Any) {
//        guard let name = txtName.text, !name.isEmpty,
//              let email = txtEmail.text, !email.isEmpty,
//              let phone = txtPhone.text, !phone.isEmpty,
//              let interestedIn = txtInterestedIn.text, !interestedIn.isEmpty,
//              let noOfSeatsText = txtNoOfSeats.text, let noOfSeats = Int(noOfSeatsText),
//              let provideDetails = txtprovideDetails.text else {
//            // Show an alert or toast to inform the user that all fields are required
//            RSOToastView.shared.show("Please fill in all fields", duration: 2.0, position: .center)
//            return
//        }
//        
//        let requestModel = BookOfficeRequestModel(
//            name: name,
//            email: email,
//            phone: phone,
//            interestedIn: interestedIn,
//            noOfSeats: noOfSeats,
//            provideDetails: provideDetails
//        )
//        bookOffice(requestModel: requestModel)
   }
    
}

extension BookAnOfficeViewController {
    enum Event {
        
        case dataLoaded
        case error(Error?)
    }
}
