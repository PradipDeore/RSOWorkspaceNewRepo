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
    func saveVisitorDetails(email: String, name: String, phone: String, indexPath: IndexPath)
}

class VisitorsTableViewCell: UITableViewCell {
    
    weak var delegate : VisitorsTableViewCellDelegate?
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    @IBOutlet weak var addButtonView: UIView!
    @IBOutlet weak var btnAdd: RSOButton!
    @IBOutlet weak var btnAddVisitors: RSOButton!
    @IBOutlet weak var lblInviteMoreVisitors: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    // Add this property
        var isEditMode: Bool = false
    var indexPath: IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
        txtEmail.isUserInteractionEnabled = true
        txtName.isUserInteractionEnabled = true
        txtPhone.isUserInteractionEnabled = true
        
        btnAdd.setCornerRadiusToButton()
        btnAddVisitors.setCornerRadiusToButton()
        btnAdd.backgroundColor = .E_6_F_0_D_9
        btnAdd.setTitleColor(.black, for: .normal)
        btnAdd.titleLabel?.font = RSOFont.poppins(size: 35, type: .Regular)
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
        let email = txtEmail.text ?? ""
        let name = txtName.text ?? ""
        let phone = txtPhone.text ?? ""
        //delegate?.addVisitors(email: email, name: name, phone: phone)
        if isEditMode {
                // Handle save functionality for edit mode
                delegate?.saveVisitorDetails(email: email, name: name, phone: phone, indexPath: indexPath!)
            } else {
                // Handle add functionality for new visitors
                delegate?.addVisitors(email: email, name: name, phone: phone)
            }
        
    }
    func resetTextFields(){
        txtEmail.text = ""
        txtName.text = ""
        txtPhone.text = ""
    }
    
    
    
    @IBAction func btnSaveAction(_ sender: Any) {
        guard let indexPath = indexPath else { return }
               let email = txtEmail.text ?? ""
               let name = txtName.text ?? ""
               let phone = txtPhone.text ?? ""
               delegate?.saveVisitorDetails(email: email, name: name, phone: phone, indexPath: indexPath)
        
    }
}
