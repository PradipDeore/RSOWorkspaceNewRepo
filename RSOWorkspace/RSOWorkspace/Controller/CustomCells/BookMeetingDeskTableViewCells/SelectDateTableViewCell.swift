//
//  SelectDateTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 29/02/24.
//

import UIKit

protocol SelectDateTableViewCellDelegate: AnyObject {
    func didSelectDate(_ actualFormatOfDate:Date)
}
class SelectDateTableViewCell: UITableViewCell {
   
    weak var delegate: SelectDateTableViewCellDelegate?

    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    @IBOutlet weak var calender: UIDatePicker!
    @IBOutlet weak var lblMonthName: UILabel!
    var selectedDate: String = "" // Property to store the selected date
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customizeCell()
        calender.minimumDate = Date()
        dateSelected(calender)
    }
      func customizeCell(){
          self.containerView.layer.cornerRadius = cornerRadius
          self.containerView.layer.masksToBounds = true
          self.addShadow()
      }

    @IBAction func dateSelected(_ sender: UIDatePicker) {
        
        let actualselectedDate = sender.date // Date
        
        // Pass the selected date to the delegate
        delegate?.didSelectDate(actualselectedDate)
        
        let monthNameFormatter = DateFormatter()
        monthNameFormatter.dateFormat = "MMMM"
        let monthName = monthNameFormatter.string(from: sender.date)
        //print("Month name: \(monthName)")
        self.lblMonthName.text = monthName
    }
}
