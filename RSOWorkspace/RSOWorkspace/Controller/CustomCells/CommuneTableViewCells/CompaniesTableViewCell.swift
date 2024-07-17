//
//  CompaniesTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 20/03/24.
//

import UIKit
protocol ButtonCompaniesTappedDelegate:AnyObject{
    func btnCompaniesTappedAction()
}

class CompaniesTableViewCell: UITableViewCell {
   
    @IBOutlet weak var btnCompanies: UIButton!
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    var delegate : ButtonCompaniesTappedDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
    }
    func customizeCell(){
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        
        self.addShadow()
    }
  
    @IBAction func btnCompaniesTappedAction(_ sender: Any) {
        delegate?.btnCompaniesTappedAction()
        
    }
}
