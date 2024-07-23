//
//  ViewFloorPlanViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/07/24.
//

import UIKit

class ViewFloorPlanViewController: UIViewController {

    @IBOutlet weak var floorPlanView: UIView!
    @IBOutlet weak var btnSelect: RSOButton!
    @IBOutlet weak var btnClose: RSOButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var confirmBookingDetails = ConfirmBookingRequestModel()
    // Data source for the collection view
    //var sittingConfigurations: [ConfigurationDetails] = []
    var floorPlansSeatingConfig:[RoomConfiguration] = []
    var seatingConfigueId: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        floorPlanView.setCornerRadiusForView()
        btnSelect.setCornerRadiusToButton()
        btnClose.setCornerRadiusToButton()
    ()
        btnClose.backgroundColor = ._768_D_70
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "floorPlanCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "floorPlanCollectionViewCell")
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectAction(_ sender: Any) {
        
        
    }
    func setData(sittingConfigurations: [RoomConfiguration]){
        self.floorPlansSeatingConfig = sittingConfigurations
        self.collectionView.reloadData()
    }
    
}
extension ViewFloorPlanViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.floorPlansSeatingConfig.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "floorPlanCollectionViewCell", for: indexPath) as! floorPlanCollectionViewCell
        let configurationDetail = floorPlansSeatingConfig[indexPath.item]
        // Load configuration image from URL using Kingfisher
        let configurationImageURLString = imageBasePath + (configurationDetail.roomConfigurationImage ?? "")
        seatingConfigueId = configurationDetail.roomConfigurationId ?? 0
        if let configurationImageURL = URL(string: configurationImageURLString) {
            cell.seatingConfigImage.kf.setImage(with: configurationImageURL)
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle item selection
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2 - 20, height: 97)
        
    }
}

