//
//  VisitorDetailsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 10/04/24.
//

import UIKit

protocol EditVisitorDetailsTableViewCellDelegate:AnyObject{
    func showeditVisitorDetailsScreen(visitorManagementId:Int,email: String, phone: String, name: String,reasonId:Int,reasonForVisit:String,arrivaldate:String,starttime:String, endtime:String, vistordetail:[MyVisitorDetail])
}
class VisitorDetailsTableViewCell: UITableViewCell {
    
    weak var delegate: EditVisitorDetailsTableViewCellDelegate?
    @IBOutlet weak var btnEdit: RSOButton!
    @IBOutlet weak var ReasonForVisitView: UIView!
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    var indexPath: IndexPath?
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndtime: UILabel!
    @IBOutlet weak var lblVisitorEmail: UILabel!
    @IBOutlet weak var lblReasonForVisit: UILabel!
    var visitorManagementId = 0
    var email = ""
    var name = ""
    var phone = ""
    var reasonId = 0
    var reasonForVisit = ""
    var arrivalDate = ""
    var start_time = ""
    var end_time = ""
    var vistordetails: [MyVisitorDetail] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        ReasonForVisitView.setCornerRadiusForView()
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
    
    func setData(item :MyVisitor){
        
        arrivalDate = item.arrivalDate ?? Date.formatSelectedDate(format: .yyyyMMdd, date: Date())
        
        if let startDateString = item.startTime {
            start_time = startDateString
            // Convert the date string in date format using 24-hour format
            let startDate = Date.dateFromString(startDateString, format: .HHmmss)
            
            // Convert the date to 12-hour format with AM/PM
            lblStartTime.text = Date.formatSelectedDate(format: .hhmma, date: startDate)
        }

        if let endDateString = item.endTime {
            end_time = endDateString
            let endDate = Date.dateFromString(endDateString, format: .HHmmss)
            
            // Convert the date to 12-hour format with AM/PM
            lblEndtime.text = Date.formatSelectedDate(format: .hhmma, date: endDate)
        }

        // Set visitor details if available
            if let visitorDetails = item.visitorDetails {
                visitorManagementId = item.visitorManagementId ?? 0
                vistordetails = visitorDetails // Set the array of visitor details
                email = visitorDetails.first?.visitor_email ?? ""
                name = visitorDetails.first?.visitor_name ?? ""
                phone = visitorDetails.first?.visitor_phone ?? ""
                reasonId = item.reasonId ?? 0
                reasonForVisit = item.reason ?? ""
                lblVisitorEmail.text = visitorDetails.first?.visitor_email
            } else {
                visitorManagementId = item.visitorManagementId ?? 0
                vistordetails = []
                email = ""
                name = ""
                phone = ""
                lblVisitorEmail.text = ""
            }
        self.lblReasonForVisit.text = item.reason
        
    }
    @IBAction func btnEditAction(_ sender: Any) {
        delegate?.showeditVisitorDetailsScreen(visitorManagementId:visitorManagementId,email: email, phone: phone, name: name,reasonId:reasonId, reasonForVisit: reasonForVisit,arrivaldate:arrivalDate,starttime:start_time, endtime:end_time, vistordetail:vistordetails)
    }
    
}
