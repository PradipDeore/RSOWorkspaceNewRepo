//
//  SelectNoOfSeatsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 27/07/24.
//

import UIKit

protocol SelectNoOfSeatsTableViewCellDelegate: AnyObject {
    func didUpdateNumberOfSeats(_ numberOfSeats: Int)
}
class SelectNoOfSeatsTableViewCell: UITableViewCell {

    weak var delegate: SelectNoOfSeatsTableViewCellDelegate?
    @IBOutlet weak var txtNoOfSeats: UITextField!
    @IBOutlet weak var btnMinus: RSOButton!
    @IBOutlet weak var btnPlus: RSOButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        setButtonsANDTextFields()  
    }

    @IBAction func btnIncrementSeatsCount(_ sender: Any) {
        if let currentCount = Int(txtNoOfSeats.text ?? "1") {
                    let updatedCount = currentCount + 1
                    txtNoOfSeats.text = "\(updatedCount)"
                    delegate?.didUpdateNumberOfSeats(updatedCount)
                } else {
                    txtNoOfSeats.text = "1"
                    delegate?.didUpdateNumberOfSeats(1)
                }
    }
    
    @IBAction func btnDecrementSeatsCount(_ sender: Any) {
        if let currentCount = Int(txtNoOfSeats.text ?? "1"), currentCount > 1 {
                    let updatedCount = currentCount - 1
                    txtNoOfSeats.text = "\(updatedCount)"
                    delegate?.didUpdateNumberOfSeats(updatedCount)
                } else {
                    txtNoOfSeats.text = "1"
                    delegate?.didUpdateNumberOfSeats(1)
                }
    }
    
    func setButtonsANDTextFields(){
        self.btnMinus.layer.cornerRadius = btnMinus.bounds.height / 2
        self.btnPlus.layer.cornerRadius = btnPlus.bounds.height / 2
        
    }
    
}
