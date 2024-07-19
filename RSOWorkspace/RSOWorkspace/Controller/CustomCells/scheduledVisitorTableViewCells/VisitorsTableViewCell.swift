//
//  VisitorsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 03/04/24.
//

import UIKit
import IQKeyboardManagerSwift
import Toast_Swift
protocol VisitorsTableViewCellDelegate:AnyObject{
    func InviteMoreVisitors()
    func addVisitors(email:String,name:String,phone:String)
    
}
protocol DisplayVisitorDetailsDelegate:AnyObject{
    func displayVisitorsDetailsCell(for indexPath: IndexPath)
}
class VisitorsTableViewCell: UITableViewCell {

    weak var delegate : VisitorsTableViewCellDelegate?
    weak var visitorDetailDelegate:DisplayVisitorDetailsDelegate?
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    
    @IBOutlet weak var btnCancel: RSOButton!
    @IBOutlet weak var addButtonView: UIView!
    @IBOutlet weak var btnAdd: RSOButton!
    @IBOutlet weak var btnAddVisitors: RSOButton!
    
    @IBOutlet weak var editButtonView: UIView!
    @IBOutlet weak var lblInviteMoreVisitors: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var btnSaveUpdatedVisitor: RSOButton!
    var indexPath: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
        txtEmail.isUserInteractionEnabled = true
        txtName.isUserInteractionEnabled = true
        txtPhone.isUserInteractionEnabled = true

        btnAdd.setCornerRadiusToButton()
        btnSaveUpdatedVisitor.setCornerRadiusToButton()
        btnCancel.setCornerRadiusToButton()
        btnCancel.backgroundColor = ._768_D_70
        btnAddVisitors.setCornerRadiusToButton()
        btnAdd.backgroundColor = .E_6_F_0_D_9
        btnAdd.setTitleColor(.black, for: .normal)
        btnAdd.titleLabel?.font = RSOFont.poppins(size: 35, type: .Regular)
        addButtonView.isHidden = false
        editButtonView.isHidden = true
        
    }

    func customizeCell(){

        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        
        let shadowColor = UIColor.black.withAlphaComponent(0.5)
        self.containerView.layer.shadowColor = shadowColor.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.containerView.layer.shadowRadius = 10.0
        self.containerView.layer.shadowOpacity = 19.0
        self.containerView.layer.masksToBounds = false
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect:  CGRect(x: 0, y: self.containerView.bounds.height - 4, width: self.containerView.bounds.width, height: 4), cornerRadius: self.containerView.layer.cornerRadius).cgPath
    }
   
    @IBAction func btnInviteMoreVisitorsTappedAction(_ sender: Any) {
        delegate?.InviteMoreVisitors()
        
    }
    
    @IBAction func btnAddTappedAction(_ sender: Any) {
        
        if let email = txtEmail.text , !email.isEmpty,
           let name = txtName.text, !name.isEmpty,
           let phone = txtPhone.text, !phone.isEmpty{
            delegate?.addVisitors(email: email, name: name, phone: phone)
        }
//        else{
//            delegate?.showToastForValidation()
//        }
        resetTextFields()
        
    }
    func resetTextFields(){
        txtEmail.text = ""
        txtName.text = ""
        txtPhone.text = ""
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        if let indexPath = indexPath {
            visitorDetailDelegate?.displayVisitorsDetailsCell(for: indexPath)
        }
    }
}
