//
//  AddPaymentMethodViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 31/07/24.
//

import UIKit

class AddPaymentMethodViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var txtCardNumber: RSOTextField!
    @IBOutlet weak var txtCardExpiryDate: RSOTextField!
    @IBOutlet weak var txtCardHolderName: RSOTextField!
    @IBOutlet weak var txtCardtype: RSOTextField!
    
    var eventHandler: ((_ event: Event) -> Void)?
    var addPaymentmethodData: PaymentMethodResponseModel?
    private var expirationDatePicker: ExpirationDatePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.setCornerRadiusForView()
        
        // Initialize ExpirationDatePicker
        expirationDatePicker = ExpirationDatePicker(textField: txtCardExpiryDate)
    }
    
    @IBAction func btnDismissView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func cardStoreAPI(number: Int, expiry: String, card_holder_name: String, card_type: String, id: Int) {
        RSOLoader.showLoader()
        let requestModel = PaymentMethodRequestModel(number: number, expiry: expiry, card_holder_name: card_holder_name, card_type: card_type)
        print("requestModel",requestModel)
        APIManager.shared.request(
            modelType: PaymentMethodResponseModel.self,
            type: PaymentMethodEndPoint.storeCardDetails(requestModel: requestModel)) { response in
                switch response {
                case .success(let response):
                    self.addPaymentmethodData = response
                    // Record updated successfully
                    DispatchQueue.main.async {
                        RSOLoader.removeLoader()
                        RSOToastView.shared.show("\(response.success ?? "")", duration: 2.0, position: .center)
                        self.clearFields()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.dismiss(animated: true, completion: nil)
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                    DispatchQueue.main.async {
                        RSOLoader.removeLoader()
                        // Unsuccessful
                        RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
                    }
                }
            }
    }
    
    @IBAction func btnSaveCardDetailsAction(_ sender: Any) {
        guard let cardNumberText = txtCardNumber.text, !cardNumberText.isEmpty else {
            RSOToastView.shared.show("Card Number cannot be empty", duration: 2.0, position: .center)
            return
        }
        
        guard RSOValidator.isValidCardNumber(cardNumberText) else {
            RSOToastView.shared.show("Invalid Card Number", duration: 2.0, position: .center)
            return
        }
        
        guard let cardNumber = Int(cardNumberText) else {
            RSOToastView.shared.show("Invalid Card Number format", duration: 2.0, position: .center)
            return
        }
        
        guard let cardExpiryDate = txtCardExpiryDate.text, !cardExpiryDate.isEmpty else {
            RSOToastView.shared.show("Card Expiry Date cannot be empty", duration: 2.0, position: .center)
            return
        }
        
        guard RSOValidator.isValidExpiryDate(cardExpiryDate) else {
            RSOToastView.shared.show("Invalid Expiry Date", duration: 2.0, position: .center)
            return
        }
        
        guard let cardHolderName = txtCardHolderName.text, !cardHolderName.isEmpty else {
            RSOToastView.shared.show("Card Holder Name cannot be empty", duration: 2.0, position: .center)
            return
        }
        
        guard let cardtype = txtCardtype.text, !cardtype.isEmpty else {
            RSOToastView.shared.show("Card Type cannot be empty", duration: 2.0, position: .center)
            return
        }
        
        guard let userId = UserHelper.shared.getUserId() else {
            return
        }
        
        self.cardStoreAPI(number: cardNumber, expiry: cardExpiryDate, card_holder_name: cardHolderName, card_type: cardtype, id: userId)
    }
    
    private func clearFields() {
        txtCardNumber.text = ""
        txtCardExpiryDate.text = ""
        txtCardHolderName.text = ""
        txtCardtype.text = ""
    }
}

extension AddPaymentMethodViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}
