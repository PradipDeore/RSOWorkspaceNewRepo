//
//  ViewFloorPlanViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 23/07/24.
//

import UIKit

protocol ViewFloorPlanDelegate: AnyObject {
    func didSelectConfiguration(_ configuration: RoomConfiguration)
}
class ViewFloorPlanViewController: UIViewController {
    
    weak var delegate: ViewFloorPlanDelegate?
    @IBOutlet weak var floorPlanView: UIView!
   // @IBOutlet weak var btnSelect: RSOButton!
    @IBOutlet weak var btnClose: RSOButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var confirmBookingDetails = ConfirmBookingRequestModel()
    // Data source for the collection view
    //var sittingConfigurations: [ConfigurationDetails] = []
    var floorPlansSeatingConfig:[RoomConfiguration] = []
    var seatingConfigueId: Int = 0
    var selectedConfigurationIndex: Int? // Track selected index
    
    @IBOutlet weak var imgFloorPlan: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        floorPlanView.setCornerRadiusForView()
        //btnSelect.setCornerRadiusToButton()
        btnClose.setCornerRadiusToButton()
        ()
        btnClose.backgroundColor = ._768_D_70
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(UINib(nibName: "floorPlanCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "floorPlanCollectionViewCell")
       
        setDataOfFloorPlan()
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func btnSelectAction(_ sender: Any) {
//        if let selectedIndex = selectedConfigurationIndex {
//            let selectedConfiguration = floorPlansSeatingConfig[selectedIndex]
//            delegate?.didSelectConfiguration(selectedConfiguration)
//            self.navigationController?.popViewController(animated: true)
//        }
//        
//    }
    func setData(sittingConfigurations: [RoomConfiguration]){
        self.floorPlansSeatingConfig = sittingConfigurations
        self.collectionView.reloadData()
    }
    
    func setDataOfFloorPlan() {
        let imgUrl = "https://rsoworkplace.com/public/storage/workplace-details-img/one_floor.jpg"
        
        if !imgUrl.isEmpty {
            let imageUrl = URL(string: imgUrl)
            self.imgFloorPlan.kf.setImage(with: imageUrl)
        }
    }

    
}

//extension ViewFloorPlanViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    // MARK: - UICollectionViewDataSource
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.floorPlansSeatingConfig.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "floorPlanCollectionViewCell", for: indexPath) as! floorPlanCollectionViewCell
//        let configurationDetail = floorPlansSeatingConfig[indexPath.item]
//        // Load configuration image from URL using Kingfisher
//        let configurationImageURLString = imageBasePath + (configurationDetail.roomConfigurationImage ?? "")
//        seatingConfigueId = configurationDetail.roomConfigurationId ?? 0
//        if let configurationImageURL = URL(string: configurationImageURLString) {
//            cell.seatingConfigImage.kf.setImage(with: configurationImageURL)
//        }
//        // Set selection state
//        let isSelected = indexPath.item == selectedConfigurationIndex
//        cell.setSelectedState(isSelected)
//        
//        return cell
//    }
//    
//    // MARK: - UICollectionViewDelegate
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedConfigurationIndex = indexPath.item
//        collectionView.reloadData()
//        
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width / 2 - 20, height: 97)
//        
//    }
//}

