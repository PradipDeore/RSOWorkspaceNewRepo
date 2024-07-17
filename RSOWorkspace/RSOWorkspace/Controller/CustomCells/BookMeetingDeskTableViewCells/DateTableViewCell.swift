//
//  DateTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/03/24.
//

import UIKit

class DateTableViewCell: UITableViewCell {
    @IBOutlet weak var txtDate: RSOTextField!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
        // Set up left view (Location icon)
               let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let locationImageView = UIImageView(image: UIImage(named: "calendar"))
               locationImageView.frame = leftView.bounds
               locationImageView.contentMode = .center
               leftView.addSubview(locationImageView)
               
               // Assign left and right views to text field
        txtDate.leftView = leftView
        txtDate.leftViewMode = .always
    }
    func customizeCell(){
        self.txtDate.font = RSOFont.inter(size: 14, type: .Bold)
      
    }
}
