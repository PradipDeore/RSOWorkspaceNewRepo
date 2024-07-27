//
//  PlanTypeViewController.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 25/07/24.
//

import UIKit

class PlanTypeViewController: UIViewController {
  @IBOutlet var collectionView: UICollectionView!
  let cellIdentifier = "PlanTypeCollectionViewCell"
  var list: [MembershipData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
      self.fetchMembershipPlan()
      collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
  func fetchMembershipPlan() {
    RSOLoader.showLoader()
    APIManager.shared.request(
        modelType: MembershipResponse.self,
        type: MembershipEndPoint.getPlans) { [weak self] response in
          DispatchQueue.main.async {
            RSOLoader.removeLoader()
            guard let self = self else { return }
            switch response {
            case .success(let response):
              self.list = response.data ?? []
              self.collectionView.reloadData()
            case .failure(let error):
              //  Unsuccessful
              RSOToastView.shared.show("\(error.localizedDescription)", duration: 2.0, position: .center)
            }
          }
        }
  }
}
extension PlanTypeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return list.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PlanTypeCollectionViewCell
    let option = list[indexPath.item]
    cell.setData(titleString: option.name, priceList: option.price, serviceList: option.services)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width - 40, height: collectionView.bounds.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
}
extension PlanTypeViewController {
    enum Event {
        case dataLoaded
        case error(Error?)
    }
}

