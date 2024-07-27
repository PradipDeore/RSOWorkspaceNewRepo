//
//  BookAnOfficeViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 29/03/24.
//

import UIKit

class LongTermOfficeBookingViewController: UIViewController {
    
    var coordinator: RSOTabBarCordinator?
    @IBOutlet weak var txtName: UITextField!
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
    var officeBookingResonseData: [OfficeBookingReasons] = []
    var intrestedInId :Int =  0
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator?.hideBackButton(isHidden:false)
        coordinator?.setTitle(title: "Book an Office")
        setButtonsANDTextFields()
        fetchOfficeBookingReasons()
    }
    
    
    private func fetchOfficeBookingReasons () {
        APIManager.shared.request(
            modelType: LongTermOfficeBookingReasonsResponse.self,
            type: LongTermOfficeBookingEndPoint.getOfficeBookingReasons) { response in
                switch response {
                case .success(let response):
                    self.officeBookingResonseData = response.data ?? []
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
    @IBAction func btnDropDown(_ sender: Any) {
        // Ensure officeBookingResonseData is populated
        guard !officeBookingResonseData.isEmpty else {
            RSOToastView.shared.show("No booking options available", duration: 2.0, position: .center)
            return
        }
        // Create action sheet
        let alertController = UIAlertController(title: "Select Option", message: nil, preferredStyle: .actionSheet)
        // Add options from officeBookingResonseData
        for reason in officeBookingResonseData {
            let action = UIAlertAction(title: reason.intrest, style: .default) { [weak self] _ in
                self?.txtInterestedIn.text = reason.intrest
                self?.intrestedInId = reason.id ?? 0
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // For iPad support
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender as? UIView
            popoverController.sourceRect = (sender as AnyObject).bounds
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnIncrementSeatsCount(_ sender: Any) {
        if let currentCount = Int(txtNoOfSeats.text ?? "0") {
            txtNoOfSeats.text = "\(currentCount + 1)"
        } else {
            txtNoOfSeats.text = "1"
        }
    }
    
    @IBAction func btnDecrementSeatsCount(_ sender: Any) {
        if let currentCount = Int(txtNoOfSeats.text ?? "0"), currentCount > 0 {
            txtNoOfSeats.text = "\(currentCount - 1)"
        } else {
            txtNoOfSeats.text = "0"
        }
    }
    
    func setButtonsANDTextFields(){
        self.btnMinus.layer.cornerRadius = btnMinus.bounds.height / 2
        self.btnPlus.layer.cornerRadius = btnPlus.bounds.height / 2
        txtprovideDetails.addPlaceholder(text: "Please provide any details")
        txtInterestedIn.setUpTextFieldView(rightImageName:"arrowdown")
        provideDetailsView.setCornerRadiusForView()
        
    }
    func longTermOfficeBookingAPI(requestModel: LongTermOfficeBookingRequestModel) {
        APIManager.shared.request(
            modelType: LongTermOfficeBookingResponse.self,
            type: LongTermOfficeBookingEndPoint.longTermOfficeBooking(requestModel: requestModel)) { [weak self] response in
                
                guard let self = self else { return }
                switch response {
                case .success(let responseData):
                    DispatchQueue.main.async {
                        // Safely unwrap status
                        if let status = responseData.status {
                            if status {
                                RSOToastView.shared.show(responseData.msg, duration: 2.0, position: .center)
                            } else {
                                RSOToastView.shared.show("Request failed: \(String(describing: responseData.msg))", duration: 2.0, position: .center)
                                self.clearFormFields()  // Clear the form fields
                            }
                        } else {
                            RSOToastView.shared.show("Status is missing in the response.", duration: 2.0, position: .center)
                        }
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
    private func clearFormFields() {
        txtName.text = ""
        txtEmail.text = ""
        txtPhone.text = ""
        txtInterestedIn.text = ""
        txtNoOfSeats.text = "0"
        txtprovideDetails.text = ""
        intrestedInId = 0  // Reset the interestedInId
    }
    @IBAction func btnSubmitTappedAction(_ sender: Any) {
       
        guard let name = txtName.text, !name.isEmpty else {
            RSOToastView.shared.show("Please fill in your name", duration: 2.0, position: .center)
            return
        }
        
        guard let email = txtEmail.text, !email.isEmpty else {
            RSOToastView.shared.show("Please fill in your email", duration: 2.0, position: .center)
            return
        }
        
        // Check if email is valid
        if !RSOValidator.isValidEmail(email) {
            RSOToastView.shared.show("Invalid email", duration: 2.0, position: .center)
            return
        }
        
        guard let phone = txtPhone.text, !phone.isEmpty else {
            RSOToastView.shared.show("Please fill in your phone number", duration: 2.0, position: .center)
            return
        }
        // check if phone number is valid
        if !RSOValidator.validatePhoneNumber(phone){
          RSOToastView.shared.show("Phone Number must contains at least 10 digits",duration: 2.0,position: .center)
          return
        }
        guard let interestedIn = txtInterestedIn.text, !interestedIn.isEmpty else {
            RSOToastView.shared.show("Please select your interest", duration: 2.0, position: .center)
            return
        }
        
        guard let noOfSeatsText = txtNoOfSeats.text, let noOfSeats = Int(noOfSeatsText) else {
            RSOToastView.shared.show("Please provide the number of seats", duration: 2.0, position: .center)
            return
        }
        
        guard let provideDetails = txtprovideDetails.text, !provideDetails.isEmpty else {
            RSOToastView.shared.show("Please provide any details", duration: 2.0, position: .center)
            return
        }
        let bookingRequest = LongTermOfficeBookingRequestModel(
            name: name,
            email: email,
            phone: phone,
            interestedIn: intrestedInId,
            noOfSeats: noOfSeats,
            provideDetails: provideDetails
        )
        //print("bookingRequest",bookingRequest)
        longTermOfficeBookingAPI(requestModel: bookingRequest)
    }
    
}

extension LongTermOfficeBookingViewController {
    enum Event {
        
        case dataLoaded
        case error(Error?)
    }
}
