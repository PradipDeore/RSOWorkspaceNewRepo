//
//  SelectDateTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 29/02/24.
//

import UIKit
import Toast_Swift

protocol SelectDateTableViewCellDelegate: AnyObject {
    func didSelectDate(_ actualFormatOfDate:Date)
}
class SelectDateTableViewCell: UITableViewCell {
    
    weak var delegate: SelectDateTableViewCellDelegate?
    
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    var bookingTypeSelectTime: BookingTypeSelectTime? // Property to store the booking type
    
    @IBOutlet weak var calender: UIDatePicker!
    @IBOutlet weak var lblMonthName: UILabel!
    var selectedDate: String = "" // Property to store the selected date
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
    
    func initWithDefaultDate() {
        calender.minimumDate = Date()
        configureDate(selectedDate: Date())
    }
    
    @IBAction func dateSelected(_ sender: UIDatePicker) {
        var selectedDate = sender.date
        configureDate(selectedDate: selectedDate)
    }
    func configureDate(selectedDate: Date) {
        // Check the booking type
        // -------------- for future use --------------
        DateTimeManager.shared.setSelectedDate(selectedDate)
        //---------------------------------------------
        if let bookingType = bookingTypeSelectTime {
            switch bookingType {
            case .desk:
                // For desk booking, disable weekends
                if isWeekend(selectedDate) {
                    self.makeToast("Desk booking is not allowed for weekends.",duration:2.0,position:.center)
                    let nextMonday = getNextMonday(from: selectedDate)
                    calender.date = nextMonday
                    // -------------- for future use --------------
                    DateTimeManager.shared.setSelectedDate(nextMonday)
                    //---------------------------------------------
                    delegate?.didSelectDate(nextMonday)
                } else {
                    delegate?.didSelectDate(selectedDate)
                }
            case .meetingRoom, .office:
                UserHelper.shared.saveSelectedDateByuser(selectedDate)
                
                delegate?.didSelectDate(selectedDate)
                
            }
        }

        // Update the label with the month name
        let monthNameFormatter = DateFormatter()
        monthNameFormatter.dateFormat = "MMMM"
        let monthName = monthNameFormatter.string(from: selectedDate)
        self.lblMonthName.text = monthName
    }
    func isWeekend(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday == 7 || components.weekday == 1 // 1 = Sunday, 7 = Saturday
    }
    
    func getNextMonday(from date: Date) -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.weekday = 2 // Monday
        return calendar.nextDate(after: date, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents) ?? date
    }
    func applyDatePickerConstraints() {
        // Configure the minimum and maximum dates based on booking type
        guard let bookingType = bookingTypeSelectTime else { return }
        
        let calendar = Calendar.current
        let today = Date()
        
        switch bookingType {
        case .desk:
            var components = DateComponents()
            components.weekday = 1 // Start of the week (Sunday)
            let startOfWeek = calendar.nextDate(after: today, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents) ?? today
            
            // Set minimum date to today
            calender.minimumDate = today
            
            // Set maximum date to the end of the week (Friday)
            components.weekday = 5 // End of the week (Friday)
            let endOfWeek = calendar.nextDate(after: today, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents) ?? today
            calender.maximumDate = endOfWeek
        case .meetingRoom, .office:
            // No date limits for meeting room and office
            calender.minimumDate = today
            calender.maximumDate = nil
        }
    }
    
    func updateCalendarConstraints() {
        // Update calendar constraints based on selected booking type
        applyDatePickerConstraints()
    }
}
