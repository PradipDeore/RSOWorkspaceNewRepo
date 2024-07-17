//
//  FindMembersCardViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 22/03/24.
//

import UIKit
import Kingfisher
class FindMembersCardViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    @IBOutlet weak var lblMemberName: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblMemberEmail: UILabel!
    @IBOutlet weak var lblMemberPhone: UILabel!
    @IBOutlet weak var btnCall: RSOButton!
    var companyName: String?
    
    @IBOutlet weak var imgProfileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.setCornerRadiusForView()
        btnCall.layer.cornerRadius = btnCall.bounds.height / 2
    }
    func configure(with member: Member, companyName :String?) {
        
        lblMemberName.text = "\(member.firstName ?? "") \(member.lastName ?? "")"
        self.companyName = companyName
        // Set up UI with member and company details
        if let companyName = companyName {
            lblCompanyName.text = "\(companyName)"
        } else {
            lblCompanyName.text = "Company: N/A"
        }
        lblMemberEmail.text = "\(member.email ?? "")"
        lblMemberPhone.text = "\(member.phone ?? "")"
        let imageUrl = member.photo
        if let imageUrl = imageUrl, !imageUrl.isEmpty {
            let url = URL(string: imageBasePath + imageUrl)
            self.imgProfileImage.kf.setImage(with: url)
        }else{
            self.imgProfileImage.image = UIImage(named: "profileIcon")
        }
    }
    
    @IBAction func btnDismissView(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
