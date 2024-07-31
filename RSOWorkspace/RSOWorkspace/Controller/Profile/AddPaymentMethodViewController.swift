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
    var eventHandler: ((_ event: Event) -> Void)?
    var addPaymentmethodData: PaymentMethodResponseModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.setCornerRadiusForView()
    }
    
    @IBAction func btnDismissView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func cardStoreAPI(card_number:String, card_expiry:String) {
        RSOLoader.showLoader()
        let requestModel = PaymentMethodRequestModel(card_number: card_number, card_expiry: card_expiry)
        print("requestModel",requestModel)
        APIManager.shared.request(
            modelType: PaymentMethodResponseModel.self,
            type: PaymentMethodEndPoint.getCardDetails(requestModel: requestModel)) { response in
                switch response {
                case .success(let response):
                    self.addPaymentmethodData = response
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
    @IBAction func btnSaveCardDetailsAction(_ sender: Any) {
        guard let cardNumber = txtCardNumber.text, !cardNumber.isEmpty else {
            RSOToastView.shared.show("Card Number cannot be empty", duration: 2.0, position: .center)
            return
        }
        
        guard RSOValidator.isValidCardNumber(cardNumber) else {
                RSOToastView.shared.show("Invalid Card Number", duration: 2.0, position: .center)
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
        
        guard let userId = UserHelper.shared.getUserId() else {
            return
        }
        self.cardStoreAPI(card_number: cardNumber, card_expiry: cardExpiryDate)
    }
    private func clearFields() {
        txtCardNumber.text = ""
        txtCardExpiryDate.text = ""
    }
    
}
extension AddPaymentMethodViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}
