//
//  AddTeamMemberViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 05/03/24.
//

import UIKit

protocol sendteamMemberNameDelegate:AnyObject{
    func sendteamMemberName(name:String)
}
class AddTeamMemberViewController: UIViewController {
    
    var teamMemberNameDelegate:sendteamMemberNameDelegate?

    @IBOutlet weak var txtSearch: RSOTextField!
    @IBOutlet weak var btnAdd: RSOButton!
    var cornerRadius: CGFloat = 10.0
    @IBOutlet weak var searchView: UIView!
    var meetingroomName = ""
    var teamMemberName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnAdd.layer.cornerRadius = btnAdd.bounds.height / 2
        txtSearch.placeholderText = "Search Team Member"
        txtSearch.customBackgroundColor = .F_2_F_2_F_2
        txtSearch.placeholderColor = ._000000
        txtSearch.placeholderFont = RSOFont.poppins(size: 16, type: .Medium)
        txtSearch.customBorderWidth = 0.0
        
        customizeCell()
    }
    
  
    func customizeCell(){

        self.searchView.layer.cornerRadius = cornerRadius
        self.searchView.layer.masksToBounds = true
        
        let shadowColor = UIColor.black.withAlphaComponent(0.5)
        self.searchView.layer.shadowColor = shadowColor.cgColor
        self.searchView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.searchView.layer.shadowRadius = 10.0
        self.searchView.layer.shadowOpacity = 19.0
        self.searchView.layer.masksToBounds = false
        self.searchView.layer.shadowPath = UIBezierPath(roundedRect:  CGRect(x: 0, y: self.searchView.bounds.height - 4, width: self.searchView.bounds.width, height: 4), cornerRadius: self.searchView.layer.cornerRadius).cgPath
    }
   
    @IBAction func btnHideViewTappedAction(_ sender: Any) {
       dismiss(animated: true)
       
    }
    @IBAction func btnAddTeamMemberTappedAction(_ sender: Any) {
        if let txtTeamMemberName = txtSearch.text{
            teamMemberName = txtTeamMemberName
        }
        teamMemberNameDelegate?.sendteamMemberName(name: teamMemberName)
        dismiss(animated: true)
    }
}
