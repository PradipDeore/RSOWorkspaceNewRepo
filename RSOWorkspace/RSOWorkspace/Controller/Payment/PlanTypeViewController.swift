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
  let list = PlanOptionList.shared.options
    override func viewDidLoad() {
        super.viewDidLoad()
      collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }

}
extension PlanTypeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return list.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PlanTypeCollectionViewCell
    let option = list[indexPath.item]
    cell.priceOptions = option.priceOptions
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width - 40, height: collectionView.bounds.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
}
