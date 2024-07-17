//
//  TimeTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/03/24.
//

import UIKit

class TimeTableViewCell: UITableViewCell {
    @IBOutlet weak var txtTime: RSOTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customizeCell()
        // Set up left view (Location icon)
               let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let locationImageView = UIImageView(image: UIImage(named: "clock"))
               locationImageView.frame = leftView.bounds
               locationImageView.contentMode = .center
               leftView.addSubview(locationImageView)
               
               // Assign left and right views to text field
        txtTime.leftView = leftView
        txtTime.leftViewMode = .always
    }

    func customizeCell(){
        self.txtTime.font = RSOFont.inter(size: 14, type: .Bold)
      
    }
    
}
