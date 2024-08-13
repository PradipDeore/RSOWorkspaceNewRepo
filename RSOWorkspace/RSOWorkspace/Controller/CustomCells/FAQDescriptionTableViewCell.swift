//
//  FAQDescriptionTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/07/24.
//

import UIKit

class FAQDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0

    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
    }
    func setData(item: FaqData){
        self.lbltitle.text = item.question
        self.lblDescription.text = item.answer
        
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
