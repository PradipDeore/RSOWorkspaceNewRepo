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
  var planSelectedIndex = 0

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
    @objc func selectPlanAction(_ sender: UIButton) {
      let planSelected = list[sender.tag]
      let priceSelected = planSelected.price?[planSelectedIndex]
      SelectedMembershipData.shared.id = planSelected.id ?? 0
      SelectedMembershipData.shared.monthlyCost = priceSelected?.price ?? ""
      SelectedMembershipData.shared.planType = priceSelected?.duration ?? ""
    }

  }
  extension PlanTypeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return list.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PlanTypeCollectionViewCell
      let option = list[indexPath.item]
      cell.continueButton.tag = indexPath.item
      cell.setData(titleString: option.name, priceList: option.price, serviceList: option.services)
      cell.continueButton.addTarget(self, action: #selector(selectPlanAction(_:)), for: .touchUpInside)
      return cell
    }
  }
  extension PlanTypeViewController {
      enum Event {
          case dataLoaded
          case error(Error?)
      }
  }
  extension PlanTypeViewController: PlanSelectDelegate {
    func didSelectPlan(index: Int) {
      self.planSelectedIndex = index
    }
  }
extension PlanTypeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: collectionView.frame.size.width-20, height: collectionView.frame.size.height)
    }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
      }
}
