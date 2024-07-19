//
//  VisitorDetailsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 10/04/24.
//

import UIKit

protocol EditVisitorDetailsTableViewCellDelegate:AnyObject{
    func showeditVisitorDetailsScreen(for indexPath: IndexPath)
}
class VisitorDetailsTableViewCell: UITableViewCell {
    
    weak var delegate: EditVisitorDetailsTableViewCellDelegate?
    @IBOutlet weak var btnEdit: RSOButton!
    @IBOutlet weak var ReasonForVisitView: UIView!
    @IBOutlet weak var btnCancel: RSOButton!
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    var indexPath: IndexPath?
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndtime: UILabel!
    @IBOutlet weak var lblVisitorEmail: UILabel!
    @IBOutlet weak var lblReasonForVisit: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        ReasonForVisitView.setCornerRadiusForView()
        btnCancel.backgroundColor = ._768_D_70
        btnCancel.isHidden = true
        btnCancel.setCornerRadiusToButton2()
        btnEdit.setCornerRadiusToButton2()
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
    
    func setData(item : MyVisitor){
        
        if let startDateString = item.startTime{
            //convert the date string in date format
            let startDate =  Date.dateFromString(startDateString, format: .hhmmss)
            //convert date in hhmma format
            lblStartTime.text = Date.formatSelectedDate(format: .hhmma, date: startDate)
        }
        if let endDateString = item.endTime{
            let endDate =  Date.dateFromString(endDateString, format: .hhmmss)
            lblEndtime.text = Date.formatSelectedDate(format: .hhmma, date: endDate)
        }
        self.lblReasonForVisit.text = item.reason
        
        
    }
    func setVisitorDetails(visitor: VisitorDetail) {
            lblVisitorEmail.text = visitor.visitorEmail
        }
    @IBAction func btnCancelAction(_ sender: Any) {
    }
    
    @IBAction func btnEditAction(_ sender: Any) {
        if let indexPath = indexPath {
            delegate?.showeditVisitorDetailsScreen(for: indexPath)
        }
    }
    
}
