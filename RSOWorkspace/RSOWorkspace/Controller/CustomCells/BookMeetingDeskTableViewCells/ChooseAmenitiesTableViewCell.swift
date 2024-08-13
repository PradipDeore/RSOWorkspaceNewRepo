//
//  ChooseAmenitiesTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 04/03/24.
//

import UIKit

protocol ChooseAmenitiesTableViewCellDelegate: AnyObject {
    func didUpdateHours(for amenityId: Int, hours: Int)
}

class ChooseAmenitiesTableViewCell: UITableViewCell  {
    
    weak var delegate: ChooseAmenitiesTableViewCellDelegate?
    @IBOutlet weak var btnsubstract: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var hoursView: UIView!
    var count = 0
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblAminityName: UILabel!
    var amenityId: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
      
        btnAdd.layer.cornerRadius = 0.5 * btnAdd.bounds.size.width
        btnAdd.clipsToBounds = true
        btnsubstract.layer.cornerRadius = 0.5 * btnsubstract.bounds.size.width
        btnsubstract.clipsToBounds = true
        
        updateCountLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func btnAddTappedAction(_ sender: Any) {
        count += 1
        updateCountLabel()
        delegate?.didUpdateHours(for: amenityId, hours: count)
    }
   
    @IBAction func btnSubstractTappedAction(_ sender: Any) {
        if count > 0{
            count -= 1
            updateCountLabel()
            delegate?.didUpdateHours(for: amenityId, hours: count)
        }
       
    }
    
    func updateCountLabel(){
        lblHours.text = "\(count)"
    }
}
