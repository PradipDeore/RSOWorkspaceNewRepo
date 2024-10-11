//
//  OnDemandServicesViewController.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 15/03/24.
//

import UIKit

class OnDemandServicesViewController: UIViewController {
    
    var coordinator: RSOTabBarCordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    var cornerRadius: CGFloat = 10.0
    var onDemandServiceArray:[Service] = []
    var eventHandler: ((_ event: Event) -> Void)?
    var serviceId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinator?.hideBackButton(isHidden:false)
        coordinator?.setTitle(title: "Concierge")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "OnDemandServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnDemandServiceCollectionViewCell")
        collectionView.backgroundColor = .white
        customizeCell()
        fetchServices()
        
    }
    func customizeCell(){
        self.containerView.layer.cornerRadius = cornerRadius
        self.containerView.layer.masksToBounds = true
        self.containerView.addShadow()
    }
    
    private func fetchServices() {
        APIManager.shared.request(
            modelType: ServiceResponse.self, // Assuming your API returns an array of Services
            type: ServicesEndPoint.onDemandServices) { response in
                switch response {
                case .success(let response):
                    self.onDemandServiceArray = response.data
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
    
}
extension OnDemandServicesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return min(onDemandServicesName.count, onDemandImageArray.count)
        return onDemandServiceArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnDemandServiceCollectionViewCell", for: indexPath) as! OnDemandServiceCollectionViewCell
        // Ensure that the index is within the bounds of the arrays
        //            guard indexPath.item < onDemandServicesName.count, indexPath.item < onDemandImageArray.count else {
        //                return cell
        //            }
        //            let services = onDemandServicesName[indexPath.item]
        //            let images = onDemandImageArray[indexPath.item]
        //            cell.lblService.text = services
        //            cell.imgService.image = UIImage(named: images)
        let itemService = onDemandServiceArray[indexPath.item]
        print("item",itemService)
        cell.setData(item: itemService)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemService = onDemandServiceArray[indexPath.item]
        let subServiceVC = UIViewController.createController(storyBoard: .ConciergeStoryboard, ofType: subServicesViewController.self)
        subServiceVC.service = itemService
        subServiceVC.coordinator = self.coordinator
        subServiceVC.subServiceId = itemService.id
        self.navigationController?.pushViewController(subServiceVC, animated: true)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.size.width
        print ("collectionViewWidth",collectionViewWidth)
        return CGSize(width: (collectionViewWidth / 3) - 20, height: 95 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension OnDemandServicesViewController {
    enum Event {
        
        case dataLoaded
        case error(Error?)
    }
}
