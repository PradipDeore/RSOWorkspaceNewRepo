//
//  PaymentMethodTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/07/24.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentMethodView: ShadowedView!
   
    @IBOutlet weak var paymentMethodBGView: UIView!
    @IBOutlet weak var txtSelectPaymentMethods: RSOTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        paymentMethodBGView.setCornerRadiusForView()
        txtSelectPaymentMethods.placeholderText = "************1881"
        txtSelectPaymentMethods.setUpTextFieldView(rightImageName:"arrowdown")
        txtSelectPaymentMethods.borderStyle = .none
    }
}
