//
//  PaymentMethodTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/07/24.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var paymentMethodView: ShadowedView!
    
    @IBOutlet weak var selectCardNumber: UIButton!
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var paymentMethodBGView: UIView!
    @IBOutlet weak var txtCardNumber: RSOTextField!
    var cardDetails: [GetCardDetails] = []
    var selectedCard:GetCardDetails?
    var pickerView: UIPickerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        paymentMethodBGView.setCornerRadiusForView()
        txtCardNumber.placeholderText = "************1881"
        txtCardNumber.setUpTextFieldView(rightImageName:"arrowdown")
        txtCardNumber.borderStyle = .none
        txtCardNumber.text = nil
        cardType.text = nil
        setupPickerView()
        self.cardDetails = CardListManager.shared.cards
        selectedCard = cardDetails.first
        if let selectedCard = selectedCard {
            txtCardNumber.text = selectedCard.number
            cardType.text = selectedCard.cardType?.capitalized
        }
        txtCardNumber.isUserInteractionEnabled = !self.cardDetails.isEmpty
        
        if self.cardDetails.isEmpty {
            CardListManager.shared.getCardDetails()
        }
    }
    
    
  
    func setupPickerView() {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Create a toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Create a done button and a flexible space item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        // Assign the picker view and toolbar to the text field's input view
        txtCardNumber.inputView = pickerView
        txtCardNumber.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        if let selectedCard = selectedCard {
            txtCardNumber.text = selectedCard.number
            cardType.text = selectedCard.cardType?.capitalized
        }
        txtCardNumber.resignFirstResponder()
    }
    
    // MARK: - UIPickerViewDataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cardDetails.count
    }
    
    // MARK: - UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let card = cardDetails[row]
        let cardNumber = card.number ?? "Unknown"
        let cardType = card.cardType ?? "Unknown"
        return "\(cardNumber) - \(cardType)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCard = cardDetails[row]
    }
}

