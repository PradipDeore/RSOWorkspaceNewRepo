//
//  SelectTimeTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/03/24.
//

import UIKit
protocol SelectTimeTableViewCellDelegate: AnyObject {
    func didSelectStartTime(_ startTime: Date)
    func didSelectEndTime(_ endTime: Date)
    func selectFulldayStatus(_ isFullDay: Bool)
}
class SelectTimeTableViewCell: UITableViewCell {

    weak var delegate: SelectTimeTableViewCellDelegate?

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
      updateButtonState()
      // set defalt date
      DispatchQueue.main.async {
        self.selectStartTime.date = Date()
        self.delegate?.didSelectStartTime(self.selectStartTime.date)
        if let nextHour = Date.adding(to: self.selectStartTime.date, hours: 2) {
          self.selectEndTime.date = nextHour
          self.delegate?.didSelectEndTime(nextHour)
        }
      }
    }
    @IBAction func selectStartTime(_ sender: UIDatePicker) {
        let selectedStartTime = sender.date
        print("Selected Start time: \(selectedStartTime)")
        // Pass the selected time to the delegate
        delegate?.didSelectStartTime(selectedStartTime)
      if let nextHour = Date.adding(to: selectedStartTime, hours: 2) {
        selectEndTime.date = nextHour
        delegate?.didSelectEndTime(nextHour)
      }
    }
 
    @IBAction func selectEndTime(_ sender: UIDatePicker) {
        let selectedEndTime = sender.date
        print("Selected End time: \(selectedEndTime)")
        delegate?.didSelectEndTime(selectedEndTime)
        
    }
  @IBAction func isFullDayAction(_ sender: Any) {
    btnBookfullDay.isSelected.toggle()
    updateButtonState()
    if btnBookfullDay.isSelected {
      if let selectedStartTime = getStartDateWithCurrentDateAnd9AM(), let selectedEndTime = getEndDateWithCurrentDateAnd6PM() {
        delegate?.didSelectStartTime(selectedStartTime)
        delegate?.didSelectEndTime(selectedEndTime)
        selectStartTime.date = selectedStartTime
        selectEndTime.date = selectedEndTime
      }
    } else {
      let selectedStartTime = Date()
      selectStartTime.date = selectedStartTime
        delegate?.didSelectStartTime(selectedStartTime)
      if let nextHour = Date.adding(to: self.selectStartTime.date, hours: 2) {
        selectEndTime.date = nextHour
        delegate?.didSelectEndTime(nextHour)
      }
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
  // Function to get the start date with current date and 9 AM time
  func getStartDateWithCurrentDateAnd9AM() -> Date? {
    return Date.dateForGivenTime(hour: 9)
  }

  // Function to get the end date with current date and 6 PM time
  func getEndDateWithCurrentDateAnd6PM() -> Date? {
    return Date.dateForGivenTime(hour: 18)
  }
}
