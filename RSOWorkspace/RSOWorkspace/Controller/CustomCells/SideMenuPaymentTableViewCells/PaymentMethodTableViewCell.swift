//
//  PaymentMethodTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/07/24.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentMethodView: ShadowedView!
   
    @IBOutlet weak var selectCardNumber: UIButton!
    @IBOutlet weak var cardType: UILabel!
    @IBOutlet weak var paymentMethodBGView: UIView!
    @IBOutlet weak var txtCardNumber: RSOTextField!
    var cardDetails: [GetCardDetails] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        paymentMethodBGView.setCornerRadiusForView()
        txtCardNumber.placeholderText = "************1881"
        txtCardNumber.setUpTextFieldView(rightImageName:"arrowdown")
        txtCardNumber.borderStyle = .none
        txtCardNumber.text = nil
        cardType.text = nil
    }
    
    
    @IBAction func btnSelectCardNumberAction(_ sender: Any) {
        guard !cardDetails.isEmpty else {
                    print("No cards available")
                    return
                }

                let actionSheet = UIAlertController(title: "Select Card", message: nil, preferredStyle: .actionSheet)

                for card in cardDetails {
                    let cardNumber = card.number ?? "Unknown"
                    let cardType = card.cardType ?? "Unknown"
                    let displayText = "\(cardNumber) - \(cardType)"
                    let action = UIAlertAction(title: displayText, style: .default) { _ in
                        self.txtCardNumber.text = cardNumber
                        self.cardType.text = cardType.capitalized
                    }
                    actionSheet.addAction(action)
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                actionSheet.addAction(cancelAction)

                if let viewController = UIApplication.shared.keyWindow?.rootViewController {
                    viewController.present(actionSheet, animated: true, completion: nil)
                }
            }
    }

