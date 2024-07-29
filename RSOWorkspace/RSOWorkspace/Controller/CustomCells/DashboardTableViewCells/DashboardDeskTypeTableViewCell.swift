//
//  DashboardDeskTypeTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 24/02/24.
//

import UIKit

protocol DashboardDeskTypeTableViewCellDelegate: AnyObject {
    func buttonTapped(type: String)
}
class DashboardDeskTypeTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: DashboardDeskTypeTableViewCellDelegate?

    var cornerRadius: CGFloat = 10.0
    
    // MARK: - Outlets
    
    @IBOutlet weak var btnMeetings: RSOButton!
    @IBOutlet weak var btnWorkspace: RSOButton!
    @IBOutlet weak var btnMembership: RSOButton!
    
    // MARK: - Lifecycle
    let selectedButtonColor = UIColor(named: "BFBFBF") ?? .black
    let defaultButtonColor  = UIColor(named: "000000") ?? .black
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeCell()
        setButtonAppearance(button: btnMeetings, backgroundColor: selectedButtonColor, textColor: .black)
        let customFont = UIFont(name: "Poppins-Bold", size: 14.0)
        btnMeetings.titleLabel?.font = customFont
        btnWorkspace.titleLabel?.font = customFont
        btnMembership.titleLabel?.font = customFont
    }
    
    // MARK: - Customization
    func customizeCell() {
        btnMeetings.layer.cornerRadius = btnMeetings.bounds.height / 2
        btnWorkspace.layer.cornerRadius = btnWorkspace.bounds.height / 2
        btnMembership.layer.cornerRadius = btnMembership.bounds.height / 2
        
    }
    func buttonSetUp(){
        setButtonAppearance(button: btnMeetings, backgroundColor: defaultButtonColor, textColor: .white)
        setButtonAppearance(button: btnWorkspace, backgroundColor: defaultButtonColor, textColor: .white)
        setButtonAppearance(button: btnMembership, backgroundColor: defaultButtonColor, textColor: .white)

    }
    
    // MARK: - Button Actions
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        buttonSetUp()
      let buttonType = sender.titleLabel?.text?.trimmingCharacters(in: .whitespaces) ?? ""
        delegate?.buttonTapped(type: buttonType)        //selectedButtonTag = sender.tag
        //reloadData()
        //myBookingListingAPI()
        
        sender.backgroundColor = selectedButtonColor
        sender.setTitleColor(.black, for: .normal)
        //selectedSection = nil
        //self.tableView.reloadData()
    }
    // MARK: - Helper Methods
    
    //    func reloadData(){
    //        switch selectedButtonTag {
    //        case 1:
    //            reloadTable(dataArray: myBookingResponseData?.mergedBookings)
    //        case 2:
    //            reloadTable(dataArray: myBookingResponseData?.bookMeetings)
    //        case 3:
    //            reloadTable(dataArray: myBookingResponseData?.bookDesks)
    //        default:
    //            break
    //        }
    //
    //    }
    func setButtonAppearance(button: UIButton, backgroundColor: UIColor, textColor: UIColor) {
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: .normal)
    }
}
