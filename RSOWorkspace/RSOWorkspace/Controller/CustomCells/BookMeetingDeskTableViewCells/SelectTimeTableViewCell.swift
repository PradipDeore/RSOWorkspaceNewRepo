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
}
class SelectTimeTableViewCell: UITableViewCell {

    weak var delegate: SelectTimeTableViewCellDelegate?

    @IBOutlet weak var btnBookfullDay: RSOButton!
    @IBOutlet weak var selectStartTime: UIDatePicker!
    @IBOutlet weak var selectEndTime: UIDatePicker!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnBookfullDay.layer.cornerRadius = btnBookfullDay.bounds.height / 2
    }
    @IBAction func selectStartTime(_ sender: UIDatePicker) {
        let selectedStartTime = sender.date
        print("Selected Start time: \(selectedStartTime)")
        // Pass the selected time to the delegate
        delegate?.didSelectStartTime(selectedStartTime)
    }
 
    @IBAction func selectEndTime(_ sender: UIDatePicker) {
        let selectedEndTime = sender.date
        print("Selected End time: \(selectedEndTime)")
        //self.selectTime.text = selectedTime
        delegate?.didSelectEndTime(selectedEndTime)
        
    }
}
