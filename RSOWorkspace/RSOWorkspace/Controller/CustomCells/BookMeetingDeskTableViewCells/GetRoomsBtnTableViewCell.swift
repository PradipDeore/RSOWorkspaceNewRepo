//
//  GetRoomsBtnTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 01/03/24.
//

import UIKit
protocol GetRoomsBtnTableViewCellDelegate : AnyObject{
    func getMeetingRooms()
}
class GetRoomsBtnTableViewCell: UITableViewCell {

    @IBOutlet weak var btnGetRooms: RSOButton!
    weak var delegate: GetRoomsBtnTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnGetRooms.setCornerRadiusToButton()
    }

    @IBAction func btnGetRoomsTappedAction(_ sender: Any) {
        delegate?.getMeetingRooms()

    }
    
}
