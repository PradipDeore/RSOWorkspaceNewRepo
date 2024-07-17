//
//  ChooseAdditionalServicesTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 07/03/24.
//

import UIKit
protocol ChooseAdditionalServicesCellDelegate: AnyObject {
    func didSelect(service: String)
    func didDeselect(service: String)
}
class ChooseAdditionalServicesTableViewCell: UITableViewCell {
   
    @IBOutlet weak var btnAdd: RSOButton!
    weak var delegate: ChooseAdditionalServicesCellDelegate?
    
    var service: String?

    @IBOutlet weak var lblServices: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnAdd.backgroundColor = .black
        btnAdd.layer.cornerRadius = 0.5 * btnAdd.bounds.size.width
        btnAdd.clipsToBounds = true
        
        btnAdd.setTitle("+", for: .normal)
        btnAdd.setTitleColor(.white, for: .normal)
       
    }

    @IBAction func btnAddAdditionalServicesTappedAction(_ sender: RSOButton) {
        guard let service = service else { return }

        if sender.currentTitle == "+" {
            sender.setTitle("-", for: .normal)
            delegate?.didSelect(service: service)
        }
        else {
            sender.setTitle("+", for: .normal)
            delegate?.didDeselect(service: service)
        }
    }
    
}
