//
//  OrderDetailTableViewCell2.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 07/09/24.
//

import UIKit

class OrderDetailTableViewCell2: UITableViewCell {

    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
   
        func setData(item: Total) {
            self.lbltitle.text = item.name
            self.lblPrice.text = item.price
        }

        func setDataOffice(item: OfficeBookingOrderDetailsTotal) {
            // Format the name using the formattedName function
            let formattedName = item.name
            self.lbltitle.text = formattedName
            self.lblPrice.text = item.price
        }

   
    
}


