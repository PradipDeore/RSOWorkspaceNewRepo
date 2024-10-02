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

/**
 1 display start time 9 and end time 6 for office and meeting
 2. For current  day if user is trying to book after 8.30 he can’t book for book fall days disable it  but he can book for future date
 4. Fot allow to select same time start and end
 5 for desk after 5.30 user can’t book for today but book for future
 */
class SelectTimeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet var timePanel: UIView!
     @IBOutlet weak var btnBookfullDay: RSOButton!
     @IBOutlet weak var selectStartTime: UIDatePicker!
     @IBOutlet weak var selectEndTime: UIDatePicker!
    @IBOutlet weak var btnBookfullDayHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var timePanelLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var timePanelTrailingConstraint: NSLayoutConstraint!
    
    
    // MARK: - Properties
    weak var delegate: SelectTimeTableViewCellDelegate?
    var bookingTypeSelectTime: BookingTypeSelectTime?
    private var isInitialSetup = true
    var eightThirtyAM: Date = Date()
    var fiveThirtyPM: Date = Date()
    var tenPM: Date = Date()
    var nineAM: Date = Date()
    var sixPM: Date = Date()
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupTimes()
        
    }
    func setupTimes() {
       // eightThirtyAM = DateTimeManager.shared.eightThirtyAM
       // fiveThirtyPM = DateTimeManager.shared.fiveThirtyPM
        tenPM = DateTimeManager.shared.tenPM
        nineAM = DateTimeManager.shared.nineAM
        sixPM = DateTimeManager.shared.sixPM
    }
    // MARK: - Setup Methods
    private func setupUI() {
        btnBookfullDay.layer.cornerRadius = btnBookfullDay.bounds.height / 2
        timePanel.layer.cornerRadius = 6
        configureTimeSelection(isStartEnabled: true, isEndEnabled: true)
        btnBookfullDay.isSelected = false
        btnBookfullDay.isUserInteractionEnabled = true
        updateFullDayButtonState()

        clearDatePickerBackground(selectEndTime)
    }
        
    func setupInitialTimeValues() {
       
        if UserHelper.shared.isGuest(){
            self.btnBookfullDay.isHidden = true
            
            
        }else{
            self.btnBookfullDay.isHidden = false
            btnBookfullDay.isUserInteractionEnabled = true
        }
        
        switch bookingTypeSelectTime {
        case .desk:
            setupInitialTimeValuesForDesk()
            configure9AMto6PM()
            // -------------- Check is start time for date paased --------------
         
            configureTimeSelection(isStartEnabled: false, isEndEnabled: false)
            btnBookfullDay.isUserInteractionEnabled = false
            btnBookfullDay.isSelected = true
            updateFullDayButtonState()
            // -------------- for desk after 5.30 user can’t book for today but book for future --------------
           //if DateTimeManager.shared.isTimePassedForEndTime(againstDate: fiveThirtyPM) {
            /*if DateTimeManager.shared.isDateToday() && DateTimeManager.shared.isCurrentTimePassedForEndTime() {
                configureTimeSelection(isStartEnabled: false, isEndEnabled: false)
                btnBookfullDay.isUserInteractionEnabled = false
                showToast("Booking is closed for today. Please select another date.")
                return
            }*/
        case .meetingRoom, .office:
            // display start time 8.30 and end time 10 for office and meeting
            setupInitialTimeValuesForOfficeRoom()
            configure9AMto6PMforMeetingOffice()
            if DateTimeManager.shared.isDateToday() {
                            self.configureForCurrentTime()
                        }
          
            if DateTimeManager.shared.isDateToday() && DateTimeManager.shared.isCurrentTimePassedForStartTime()  {
                            btnBookfullDay.isUserInteractionEnabled = false
                           
            } else {
                btnBookfullDay.isUserInteractionEnabled = true
            }
            updateFullDayButtonState()
            btnBookfullDay.isSelected = false
            updateFullDayButtonState()
            
            // -------------- Check is end time for date paased --------------
            if DateTimeManager.shared.isCurrentTimePassedForEndTime() {
                configureTimeSelection(isStartEnabled: false, isEndEnabled: false)
                btnBookfullDay.isUserInteractionEnabled = false
                showToast("Booking is closed for today. Please select another date.")
                return
            }
            
            if UserHelper.shared.isGuest(){
                if DateTimeManager.shared.isCurrentTimePassedForEndTime(){
                    configureTimeSelection(isStartEnabled: false, isEndEnabled: false)
                    btnBookfullDay.isUserInteractionEnabled = false
                    showToast("Booking is closed for today. Please select another date.")
                    return
                }
            }
          

        default:
            break
        }
    
        // Call API with default values
        delegate?.didSelectStartTime(selectStartTime.date)
        delegate?.didSelectEndTime(selectEndTime.date)
        isInitialSetup = false
    }
    
    private func setupInitialTimeValuesForDesk() {
        configureDatePicker(selectStartTime, minDate: nineAM, maxDate: sixPM)
        configureDatePicker(selectEndTime, minDate: nineAM, maxDate: sixPM)

    }
    private func setupInitialTimeValuesForOfficeRoom() {
        configureDatePicker(selectStartTime, minDate: nineAM, maxDate: tenPM)
        configureDatePicker(selectEndTime, minDate: nineAM, maxDate: tenPM)

    }
    
    // MARK: - Actions
    @IBAction private func selectStartTime(_ sender: UIDatePicker) {
        guard !isInitialSetup else { return }
        let startTime = sender.date
        delegate?.didSelectStartTime(startTime)
        validateStartEndTime()
        UserHelper.shared.saveSelectedTimes(startTime: startTime, endTime: selectEndTime.date)
        
        // -------------- for future use startTime --------------
        DateTimeManager.shared.setStartTime(startTime)
        //----------------------------------------------------
    }
    
    @IBAction private func selectEndTime(_ sender: UIDatePicker) {
        guard !isInitialSetup else { return }
        let endTime = sender.date
        delegate?.didSelectEndTime(endTime)
        validateStartEndTime()
        UserHelper.shared.saveSelectedTimes(startTime: selectStartTime.date, endTime: endTime)
        
        // -------------- for future use endTime --------------
        DateTimeManager.shared.setEndTime(endTime)
        //----------------------------------------------------
    }
    
    @IBAction private func toggleFullDaySelection(_ sender: Any) {
        btnBookfullDay.isSelected.toggle()
        updateFullDayButtonState()
        btnBookfullDay.isSelected ? selectFullDay() : deselectFullDay()
    }
    
    // MARK: - Helper Methods
    private func selectFullDay() {
        configureTimeSelection(isStartEnabled: false, isEndEnabled: false)
        let startTime = nineAM
        let endTime = sixPM
        // Update the date pickers to reflect the full day times
        selectStartTime.date = startTime
        selectEndTime.date = endTime
        
        // Notify the delegate of the full day time selection
        delegate?.didSelectStartTime(startTime)
        delegate?.didSelectEndTime(endTime)
        
        // For future use, set these times in DateTimeManager
        DateTimeManager.shared.setStartTime(startTime)
        DateTimeManager.shared.setEndTime(endTime)
    }

    private func deselectFullDay() {
            configureTimeSelection(isStartEnabled: true, isEndEnabled: true)
            guard bookingTypeSelectTime != .desk else { return }
            let startTime = nineAM
            let endTime = sixPM
            
            // Update the date pickers to reflect the full day times
            selectStartTime.date = startTime
            selectEndTime.date = endTime
            
            // Notify the delegate of the full day time selection
            delegate?.didSelectStartTime(startTime)
            delegate?.didSelectEndTime(endTime)
            
            // For future use, set these times in DateTimeManager
            DateTimeManager.shared.setStartTime(startTime)
            DateTimeManager.shared.setEndTime(endTime)
        }
    private func configureForCurrentTime() {
        let now = Date()
        selectStartTime.date = now
        //selectEndTime.date = tenPM
       // configureTimeSelection(isStartEnabled: true, isEndEnabled: true)
        DateTimeManager.shared.setStartTime(now)
    }
    private func configure9AMto6PMforMeetingOffice() {
        selectStartTime.date = nineAM
        selectEndTime.date = sixPM
        configureTimeSelection(isStartEnabled: true, isEndEnabled: true)
        // -------------- for future use startTime --------------
        DateTimeManager.shared.setStartTime(nineAM)
        // -------------- for future use endTime --------------
        DateTimeManager.shared.setEndTime(sixPM)
        //----------------------------------------------------
    }
    private func configure9AMto6PM() {
        selectStartTime.date = nineAM
        selectEndTime.date = sixPM
        configureTimeSelection(isStartEnabled: true, isEndEnabled: true)
    }
    private func updateFullDayButtonState() {
        btnBookfullDay.backgroundColor = btnBookfullDay.isSelected ? .black : .lightGray
        delegate?.selectFulldayStatus(btnBookfullDay.isSelected)
        self.timePanelLeadingConstraint.constant = btnBookfullDay.isHidden ? 25 : 165
        self.timePanelTrailingConstraint.priority = btnBookfullDay.isHidden ? UILayoutPriority(250) : UILayoutPriority(1000)



    }
    
    private func adjustEndDateToAfterStartTime() {
        let nextHour = Calendar.current.date(byAdding: .hour, value: 1, to: selectStartTime.date) ?? selectStartTime.date
        selectEndTime.date = min(nextHour, tenPM)
        delegate?.didSelectEndTime(selectEndTime.date)
    }
    
    private func validateStartEndTime() {
        if selectEndTime.date <= selectStartTime.date {
            let validEndTime = Calendar.current.date(byAdding: .minute, value: 30, to: selectStartTime.date) ?? selectStartTime.date
            selectEndTime.date = validEndTime
            delegate?.didSelectEndTime(validEndTime)
            showToast("End time must be greater than the start time.")
        }
    }
    
    private func showToast(_ message: String) {
        RSOToastView.shared.show(message, duration: 5.0, position: .center)
    }
    
    private func clearDatePickerBackground(_ datePicker: UIDatePicker) {
        if let bgView = datePicker.subviews.first?.subviews.first?.subviews.first {
            bgView.backgroundColor = .clear
        }
    }
    
    private func configureDatePicker(_ picker: UIDatePicker, minDate: Date, maxDate: Date) {
        picker.datePickerMode = .time
        //picker.minuteInterval = 30
        picker.minimumDate = minDate
        picker.maximumDate = maxDate
    }
    
    private func configureTimeSelection(isStartEnabled: Bool, isEndEnabled: Bool) {
        selectStartTime.isUserInteractionEnabled = isStartEnabled
        selectEndTime.isUserInteractionEnabled = isEndEnabled
    }
    
    private func disableFullDayButton() {
        btnBookfullDay.isUserInteractionEnabled = false
    }
}
