//
//  AddPicsTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 18/03/24.
//

import UIKit

protocol AddPicsTableViewCellDelegate:AnyObject{
    func openGallery()
}
class AddPicsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    weak var delegate:AddPicsTableViewCellDelegate?
    @IBOutlet weak var btnAdd: RSOButton!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var addPicsLabel: UILabel! // Add IBOutlet for the label
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoView.setCornerRadiusForView()
        
        btnAdd.backgroundColor = .black
        btnAdd.layer.cornerRadius = 0.5 * btnAdd.bounds.size.width
        btnAdd.clipsToBounds = true
        
        btnAdd.setTitle("+", for: .normal)
        btnAdd.setTitleColor(.white, for: .normal)
        
    }
    @IBAction func btnAddPicAction(_ sender: RSOButton) {
        delegate?.openGallery()
    }
    func displayPhoto(_ image: UIImage) {
        // Set the selected image to the photoImageView
           photoImageView.image = image
              
       }
    func resetImages() {
        photoImageView.image = nil
    }
}
