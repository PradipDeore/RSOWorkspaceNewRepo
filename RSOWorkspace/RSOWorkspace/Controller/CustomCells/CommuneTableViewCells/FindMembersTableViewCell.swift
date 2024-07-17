//
//  FindMembersTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 20/03/24.
//

import UIKit
protocol BrowseDirectoryActionDelegate:AnyObject{
    func btnBrowseDirectoryTappedAction()

}
class FindMembersTableViewCell: UITableViewCell {
   
    weak var delegate : BrowseDirectoryActionDelegate?
    @IBOutlet weak var txtSearch: RSOTextField!
    @IBOutlet weak var btnBrowseDirectory: RSOButton!
    var cornerRadius: CGFloat = 10.0
    @IBOutlet weak var searchView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnBrowseDirectory.layer.cornerRadius = btnBrowseDirectory.bounds.height / 2
        
        txtSearch.layer.cornerRadius = txtSearch.bounds.height / 2
        txtSearch.placeholderText = "Search Members"
        txtSearch.customBackgroundColor = .F_0_F_0_F_0
        txtSearch.placeholderColor = ._595959
        txtSearch.placeholderFont = RSOFont.inter(size: 14, type: .SemiBold)
        txtSearch.customBorderWidth = 0.0
        txtSearch.setUpTextFieldView(rightImageName:"search")
        
        
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
    
    @IBAction func btnBrowseDirectoryTappedAction(_ sender: Any) {
        delegate?.btnBrowseDirectoryTappedAction()
        
    }
}
