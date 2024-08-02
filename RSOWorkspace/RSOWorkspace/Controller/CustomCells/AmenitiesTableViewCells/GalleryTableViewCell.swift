//
//  GalleryTableViewCell.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/04/24.
//

import UIKit

class GalleryTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
   
    var galleryData : [Gallery] = []
    var eventHandler: ((_ event: Event) -> Void)?
    private var locationID: Int?
    
    override func awakeFromNib() {
            super.awakeFromNib()
            
        collectionView.delegate = self
        collectionView.dataSource = self
       
        collectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GalleryCollectionViewCell")
            
            // Set collection view layout
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumInteritemSpacing = 5
                layout.scrollDirection = .horizontal
            }
        }
     func setLocationID(_ id: Int) {
            self.locationID = id
            fetchGallery(locationID: id)
        }
        
     func fetchGallery(locationID:Int) {
         DispatchQueue.main.async {
             RSOLoader.showLoader()
         }
        APIManager.shared.request(
            modelType: LocationGalleryResponseModel.self,
            type: GalleryEndPoint.locationGallery(locationID: locationID)) { response in
                switch response {
                case .success(let response):
                    self.galleryData = response.data ?? []
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    RSOLoader.removeLoader()
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return galleryData.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
            // Configure cell appearance here
            let item = galleryData[indexPath.item]
            cell.setData(item: item)
            return cell
        }
        
        // MARK: - UICollectionViewDelegateFlowLayout methods
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat
//            if indexPath.row % 2 == 0 {
//                // For even rows, use item size 146
//                itemWidth = 146
//            }
        //else {
//                // For odd rows, use item size 246
//                itemWidth = 246
//            }
            let itemHeight: CGFloat = 209 // Set the item height

            return CGSize(width: 146, height: itemHeight)
    }
}

extension GalleryTableViewCell {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
   
}
