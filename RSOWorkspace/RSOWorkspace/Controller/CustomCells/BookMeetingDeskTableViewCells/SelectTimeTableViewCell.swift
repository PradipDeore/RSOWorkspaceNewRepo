//
//  SelectTimeTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/03/24.
//

import UIKit
import Toast_Swift
enum BookingTypeSelectTime {
    case desk
    case meetingRoom
    case office
}

protocol SelectTimeTableViewCellDelegate: AnyObject {
    func didSelectStartTime(_ startTime: Date)
    func didSelectEndTime(_ endTime: Date)
    func selectFulldayStatus(_ isFullDay: Bool)
}

class SelectTimeTableViewCell: UITableViewCell {
    
    weak var delegate: SelectTimeTableViewCellDelegate?
    var bookingTypeSelectTime:  BookingTypeSelectTime?
    @IBOutlet var timePanel: UIView!
    @IBOutlet weak var btnBookfullDay: RSOButton!
    @IBOutlet weak var selectStartTime: UIDatePicker!
    @IBOutlet weak var selectEndTime: UIDatePicker!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnBookfullDay.layer.cornerRadius = btnBookfullDay.bounds.height / 2
        if let bgView = selectEndTime.subviews.first?.subviews.first?.subviews.first {
            bgView.backgroundColor = .clear
        }
        timePanel.layer.cornerRadius = 6
        
        // Set default times based on booking type
        DispatchQueue.main.async {
            if let type = self.bookingTypeSelectTime {
                switch type {
                case .desk:
                    // Set default start and end times for desk
                    let startTime = self.getSpecificTime(hour: 8, minute: 30) // 8:30 AM
                    let endTime = self.getSpecificTime(hour: 17, minute: 30) // 5:30 PM
                    self.selectStartTime.date = startTime
                    self.selectEndTime.date = endTime
                    self.selectStartTime.isUserInteractionEnabled = false
                    self.selectEndTime.isUserInteractionEnabled = false
                    
                    // Configure "Book Full Day" button for desk booking
                    self.btnBookfullDay.isSelected = true
                    self.btnBookfullDay.backgroundColor = UIColor.black
                    self.btnBookfullDay.isUserInteractionEnabled = false
                    // Notify the delegate with the fixed start and end times
                    self.delegate?.didSelectStartTime(startTime)
                    self.delegate?.didSelectEndTime(endTime)
                       
//                    print("Desk Booking Start Time: \(formatDateForDisplay(startTime))")
//                    print("Desk Booking End Time: \(formatDateForDisplay(endTime))")
//                    func formatDateForDisplay(_ date: Date) -> String {
//                        let formatter = DateFormatter()
//                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                        formatter.timeZone = TimeZone.current // Set to the current system timezone (e.g., IST if your device is in India)
//                        return formatter.string(from: date)
//                    }
//                    
                case .meetingRoom:
                    // Set initial start time to current time and enable date pickers
                    self.selectStartTime.date = Date()
                    self.setEndDateLaterStartDate()
                    self.selectStartTime.isUserInteractionEnabled = true
                    self.selectEndTime.isUserInteractionEnabled = true
                    
                    // Allow interaction with "Book Full Day" button for other booking types
                    self.btnBookfullDay.isSelected = false
                    self.updateButtonState()
                    self.btnBookfullDay.isUserInteractionEnabled = true
                    
                    self.delegate?.didSelectStartTime(self.selectStartTime.date)
                    self.delegate?.didSelectEndTime(self.selectEndTime.date)
                    
                case .office:
                    // Set initial start time to current time and enable date pickers
                    self.selectStartTime.date = Date()
                    self.setEndDateLaterStartDate()
                    self.selectStartTime.isUserInteractionEnabled = true
                    self.selectEndTime.isUserInteractionEnabled = true
                    
                    // Allow interaction with "Book Full Day" button for other booking types
                    self.btnBookfullDay.isSelected = false
                    self.updateButtonState()
                    self.btnBookfullDay.isUserInteractionEnabled = true
                    self.delegate?.didSelectStartTime(self.selectStartTime.date)
                    self.delegate?.didSelectEndTime(self.selectEndTime.date)
                }
            }
        }
    }
   
    @IBAction func selectStartTime(_ sender: UIDatePicker) {
        let selectedStartTime = sender.date
        let currentTime = Date()

        // If "Book Full Day" is selected, restrict start time to be no earlier than 8:30 AM
        if btnBookfullDay.isSelected {
            let fullDayStartTime = getSpecificTime(hour: 8, minute: 30)
            
            // Ensure the start time is not before 8:30 AM
            if selectedStartTime < fullDayStartTime {
                selectStartTime.date = fullDayStartTime
                RSOToastView.shared.show("Start time cannot be before 8:30 AM for full-day bookings.", duration: 2.0, position: .center)
            }
            // Manually adjust the end time if needed, but do not reset it automatically
            let fullDayEndTime = getSpecificTime(hour: 22, minute: 0) // 10:00 PM
            if selectEndTime.date > fullDayEndTime {
                selectEndTime.date = fullDayEndTime
                RSOToastView.shared.show("End time cannot be after 10:00 PM for full-day bookings.", duration: 2.0, position: .center)
            }
        } else {
            // For non-full-day bookings, set end time based on the start time
            setEndDateLaterStartDate()
        }
        // Notify the delegate about the selected start time
        delegate?.didSelectStartTime(selectStartTime.date)
    }

    @IBAction func selectEndTime(_ sender: UIDatePicker) {
        let selectedEndTime = sender.date
        delegate?.didSelectEndTime(selectedEndTime)
        validateStartEndTime()
    }
    
    @IBAction func isFullDayAction(_ sender: Any) {
        btnBookfullDay.isSelected.toggle()
        updateButtonState()
        if btnBookfullDay.isSelected {
            let selectedStartTime = getSpecificTime(hour: 8, minute: 30)
            let selectedEndTime = getSpecificTime(hour: 17, minute: 30) // 05.30
            delegate?.didSelectStartTime(selectedStartTime)
            delegate?.didSelectEndTime(selectedEndTime)
            selectStartTime.date = selectedStartTime
            selectEndTime.date = selectedEndTime
            
            // Prevent selecting a start time before 8:30 AM
            if selectStartTime.date < getSpecificTime(hour: 8, minute: 30) {
                selectStartTime.date = getSpecificTime(hour: 8, minute: 30)
                delegate?.didSelectStartTime(selectStartTime.date)
            }
        }else {
            let selectedStartTime = Date()
            selectStartTime.date = selectedStartTime
            delegate?.didSelectStartTime(selectedStartTime)
            setEndDateLaterStartDate()
        }
    }
    
    func updateButtonState() {
        if btnBookfullDay.isSelected {
            btnBookfullDay.backgroundColor = UIColor.black
        } else {
            btnBookfullDay.backgroundColor = UIColor.lightGray
        }
        self.delegate?.selectFulldayStatus(btnBookfullDay.isSelected)
    }
    
    func setEndDateLaterStartDate() {
        let startDate = self.selectStartTime.date
        if let nextHour = Calendar.current.date(byAdding: .hour, value: 1, to: startDate) {
            // Check if the end time is valid (within the same day and greater than the start time)
            if Calendar.current.isDate(nextHour, inSameDayAs: startDate) && nextHour > startDate {
                selectEndTime.date = nextHour
                delegate?.didSelectEndTime(nextHour)
            } else {
                // If adding 1 hour crosses midnight, set the end time to 11:59 PM of the same day
                if let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: startDate) {
                    selectEndTime.date = endOfDay
                    delegate?.didSelectEndTime(endOfDay)
                }
            }
        }
    }
    
    func getSpecificTime(hour: Int, minute: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func validateStartEndTime() {
        if selectStartTime.date > selectEndTime.date {
            setEndDateLaterStartDate()
            RSOToastView.shared.show("End time must be greater than start time.", duration: 2.0, position: .center)
        }
    }
    
}


