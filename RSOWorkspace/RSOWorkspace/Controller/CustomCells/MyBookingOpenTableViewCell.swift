//
//  MyBookingOpenTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/02/24.
//

import UIKit

protocol MeetingBookingDelegate: AnyObject {
    func displayBookingQRCode(forMeeting item: MeetingBooking)
}

protocol EnterpriseBookingDelegate: AnyObject {
    func displayBookingQRCode(forEnterprise item: EnterpriseAllBookingDetails)
}

class MyBookingOpenTableViewCell: UITableViewCell {
    
    weak var meetingDelegate: MeetingBookingDelegate?
    weak var enterpriseDelegate: EnterpriseBookingDelegate?
   
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
    
    @IBOutlet weak var btnBokingKey: UIButton!
    var bookingItemMeeting: MeetingBooking?
    var bookingItemEnterprise: EnterpriseAllBookingDetails?
    
    @IBOutlet weak var btnViewAssignedSpace: RSOButton!
    
    @IBOutlet weak var btnCheckIn: RSOButton!
    
    @IBOutlet weak var btnView: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customizeCell()
    }
    func customizeCell(){
        
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        btnViewAssignedSpace.setCornerRadiusToButton2()
        btnCheckIn.setCornerRadiusToButton2()
        btnCheckIn.backgroundColor = .E_2_F_0_D_9
        btnCheckIn.setTitleColor(.black, for: .normal)
        self.addShadow()
    }
    
    func setData(item : MeetingBooking){
        self.bookingItemMeeting = item
        self.bookingItemEnterprise = nil

        if let startDateString = item.startTime{
           
            let startDate = Date.dateFromString(startDateString, format: .HHmmss)
            lblStartTime.text = Date.formatSelectedDate(format: .hhmma, date: startDate)
        }
        if let endTimeString = item.endTime {
            let endDate = Date.dateFromString(endTimeString, format: .HHmmss)
            print("End time from API response: ", endDate ?? "")
            lblEndTime.text = Date.formatSelectedDate(format: .hhmma, date: endDate)
        }

        if item.listType == "meeting"
        {
            self.lblRoomName.text = "\(item.roomName ?? "")"

        }else {
            self.lblRoomName.text =  "Desk No \(item.deskNo ?? "") Floor 1"
        }
        self.lblStatus.text = item.status
      
    }

    
    func setEnterpriseBookingData(item : EnterpriseAllBookingDetails){
        self.bookingItemEnterprise = item
        self.bookingItemMeeting = nil
        
        if let startDateString = item.startTime{
            let startDate = Date.dateFromString(startDateString, format: .HHmmss)
            lblStartTime.text = Date.formatSelectedDate(format: .hhmma, date: startDate)
        }
        if let endTimeString = item.endTime {
            let endDate = Date.dateFromString(endTimeString, format: .HHmmss)
            print("End time from API response: ", endDate ?? "")
            lblEndTime.text = Date.formatSelectedDate(format: .hhmma, date: endDate)
        }
        self.lblRoomName.text = "\(item.roomName ?? "")"
        self.lblStatus.text = item.status
        
    }
    
    @IBAction func btnBookingKeyAction(_ sender: Any) {
        if let meetingItem = bookingItemMeeting {
               meetingDelegate?.displayBookingQRCode(forMeeting: meetingItem)
           } else if let enterpriseItem = bookingItemEnterprise {
               enterpriseDelegate?.displayBookingQRCode(forEnterprise: enterpriseItem)
           }
    }
    
}
extension Date {
    static func dateFromString(_ dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // To handle locale issues
        return dateFormatter.date(from: dateString)
    }
    

    static func formatSelectedDate(format: String, date: Date?) -> String? {
        guard let date = date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
