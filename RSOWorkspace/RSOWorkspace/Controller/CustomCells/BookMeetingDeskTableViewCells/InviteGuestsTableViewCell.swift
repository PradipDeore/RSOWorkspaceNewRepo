//
//  InviteGuestsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 04/03/24.
//

import UIKit

protocol InviteGuestsTableViewCellDelegate:AnyObject{
    func btnInviteGuestsTappedAction()
    func btnDeleteGuest(buttonTag:Int)

}
class InviteGuestsTableViewCell: UITableViewCell {
    
    weak var delegate:InviteGuestsTableViewCellDelegate?
   
    //@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnAdd: RSOButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblGuestName: UILabel!
    @IBOutlet weak var guestEmailView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnAdd.backgroundColor = .white
        btnAdd.layer.cornerRadius = 0.5 * btnAdd.bounds.size.width
        btnAdd.clipsToBounds = true
        
        guestEmailView.setCornerRadiusForView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func btnInviteGuestsTappedAction(_ sender: Any) {
        delegate?.btnInviteGuestsTappedAction()
    }
    
    @IBAction func btndeleTappedAction(_ sender: UIButton) {
        delegate?.btnDeleteGuest(buttonTag: sender.tag)
    }
   
    
}
