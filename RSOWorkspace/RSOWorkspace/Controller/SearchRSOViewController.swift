//
//  SearchRSOViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 26/02/24.
//

import UIKit

class SearchRSOViewController: UIViewController {

    @IBOutlet weak var txtSearch: RSOTextField!
    @IBOutlet weak var btnSearch: RSOButton!
    var cornerRadius: CGFloat = 10.0
    @IBOutlet weak var searchView: UIView!
    var meetingroomName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSearch.layer.cornerRadius = btnSearch.bounds.height / 2
        txtSearch.placeholderText = "Search  RSO"
        txtSearch.customBackgroundColor = .F_2_F_2_F_2
        txtSearch.placeholderColor = ._000000
        txtSearch.placeholderFont = RSOFont.poppins(size: 16, type: .Medium)
        txtSearch.customBorderWidth = 0.0
        
        customizeCell()
    }
    
    @IBAction func btnHideViewTappedAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    @IBAction func btnSearchTappedAction(_ sender: Any) {
        //let selectedCompany = companiesListArray[index]
        
        //if let txtSearch = txtSearch.text, !txtSearch.isEmpty{
            
            let deskListingVC = UIViewController.createController(storyBoard: .Products, ofType: RoomListingViewController.self)
           // deskListingVC.searchMeetingRooms = txtSearch 
            deskListingVC.isSearchEnabled = true
            self.present(deskListingVC, animated: true)
        //}
    }
}
