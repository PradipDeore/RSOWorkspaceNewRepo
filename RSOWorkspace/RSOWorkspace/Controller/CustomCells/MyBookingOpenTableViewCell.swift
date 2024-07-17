//
//  MyBookingOpenTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/02/24.
//

import UIKit

class MyBookingOpenTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnBooking: UIButton!
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblAM: UILabel!
    @IBOutlet weak var lblPM: UILabel!
    @IBOutlet weak var lblRoomName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customizeCell()
    }
    func customizeCell(){
        
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        
        self.addShadow()
    }
    func setData(item : MeetingBooking){
        
        if let startDateString = item.startTime{
            //convert the date string in date format
            let startDate =  Date.dateFromString(startDateString, format: .hhmmss)
            //convert date in hhmma format
            lblStartTime.text = Date.formatSelectedDate(format: .hhmma, date: startDate)
        }
        if let endDateString = item.endTime{
            let endDate =  Date.dateFromString(endDateString, format: .hhmmss)
            lblEndTime.text = Date.formatSelectedDate(format: .hhmma, date: endDate)
        }
        if item.listType == "meeting"
        {
            self.lblRoomName.text = "\(item.roomName ?? "")"

        }else {
            self.lblRoomName.text =  "Desk No \(item.deskNo ?? "") Floor \(item.floorMapId ?? "")"
        }
        self.lblStatus.text = item.status
      
    }
}
