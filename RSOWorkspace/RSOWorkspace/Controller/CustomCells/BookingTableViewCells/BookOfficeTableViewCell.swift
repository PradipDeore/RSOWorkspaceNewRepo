//
//  BookOfficeTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 27/02/24.
//

import UIKit
protocol BookOfficeTableViewCellDelegate:AnyObject{
    func NavigateToShortTermOfficeBooking()
    func NavigateToLongTermOfficeBooking()
}
class BookOfficeTableViewCell: UITableViewCell {

    weak var delegate: BookOfficeTableViewCellDelegate?
    @IBOutlet weak var btnShortTermBooking: RSOButton!
    @IBOutlet weak var btnLongTermBooking: RSOButton!
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0

    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
    }
    func customizeCell(){
        self.btnShortTermBooking.layer.cornerRadius = btnShortTermBooking.bounds.height / 2
        self.btnLongTermBooking.layer.cornerRadius = btnLongTermBooking.bounds.height / 2
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        self.addShadow()
    }
    
    @IBAction func btnShortTermBookingAction(_ sender: Any) {
        delegate?.NavigateToShortTermOfficeBooking()
    }
    @IBAction func btnLongTermBookingAction(_ sender: Any) {
        delegate?.NavigateToLongTermOfficeBooking()
    }
}
