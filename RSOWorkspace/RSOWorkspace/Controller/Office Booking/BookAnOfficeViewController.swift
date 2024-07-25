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
    
    @IBAction func btnDropDown(_ sender: Any) {
        let alertController = UIAlertController(title: "Select Option", message: nil, preferredStyle: .actionSheet)
        let privateOfficeAction = UIAlertAction(title: "Private Office", style: .default) { [weak self] _ in
            self?.txtInterestedIn.text = "Private Office"
        }
        let officeSuiteAction = UIAlertAction(title: "Office Suite", style: .default) { [weak self] _ in
            self?.txtInterestedIn.text = "Office Suite"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(privateOfficeAction)
        alertController.addAction(officeSuiteAction)
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
    guard let name = txtName.text, !name.isEmpty else {
            RSOToastView.shared.show("Please fill in your name", duration: 2.0, position: .center)
            return
        }
        
        guard let email = txtEmail.text, !email.isEmpty else {
            RSOToastView.shared.show("Please fill in your email", duration: 2.0, position: .center)
            return
        }
        
        guard let phone = txtPhone.text, !phone.isEmpty else {
            RSOToastView.shared.show("Please fill in your phone number", duration: 2.0, position: .center)
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
