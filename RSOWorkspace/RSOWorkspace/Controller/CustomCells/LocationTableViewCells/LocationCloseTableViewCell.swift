//
//  LocationCloseTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/04/24.
//

import UIKit

class LocationCloseTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnLocationArrow: UIButton!
    var cornerRadius: CGFloat = 10.0

    var isExpanded = false // Add this property
       
       @IBAction func btnLocationArrowAction(_ sender: UIButton) {
           isExpanded.toggle() // Toggle the state
           
           // Reload the section containing this cell
           if let tableView = superview as? UITableView {
               tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
           }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
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
    
    
}
