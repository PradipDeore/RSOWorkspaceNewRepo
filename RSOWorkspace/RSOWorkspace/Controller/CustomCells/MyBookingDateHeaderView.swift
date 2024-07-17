//
//  MyBookingDateHeaderView.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 04/04/24.
//

import UIKit

class MyBookingDateHeaderView: UITableViewHeaderFooterView {

    let dayLabel = UILabel()
    let dateMonthLabel = UILabel()
       
       override init(reuseIdentifier: String?) {
           super.init(reuseIdentifier: reuseIdentifier)
           
           // Configure day label
           dayLabel.textAlignment = .left
           dayLabel.font = RSOFont.poppins(size: 16, type: .Regular)
           addSubview(dayLabel)
           
           // Configure date month label
           dateMonthLabel.textAlignment = .right
           dateMonthLabel.font = RSOFont.poppins(size: 16, type: .Regular)
           addSubview(dateMonthLabel)
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       override func layoutSubviews() {
           super.layoutSubviews()
           
           // Layout day label
           dayLabel.frame = CGRect(x: 25, y: 0, width: bounds.width / 2 - 8, height: bounds.height)
           
           dateMonthLabel.frame = CGRect(x: bounds.width / 2 + 8, y: 0, width: bounds.width / 2 - 35, height: bounds.height)

       }

}
