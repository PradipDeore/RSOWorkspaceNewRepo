//
//  RSOTab.swift
//  TabDemo
//
//  Created by Pradip Deore on 22/02/24.
//

import Foundation
import UIKit

enum RSOTabItem: Int, CaseIterable {
  case home
  case booking
  case concierge
  case commune
  case more
  

  func getTitle() -> String {
    switch self {
    case .home:
      return "Home"
    case .booking:
      return "Booking"
    case .concierge:
      return "Concierge"
    case .commune:
      return "Commune"
    case .more:
      return "More"
    
    }
  }

  func getImages() -> (image: UIImage?, selectedImage: UIImage?) {
      switch self {
      case .home:
          return (UIImage(named: "home_unselected"),
                  UIImage(named: "home_selected"))
          
      case .booking:
          return (UIImage(named: "booking_unselected"),
                  UIImage(named: "booking_selected"))
      case .concierge:
          return (UIImage(named: "concierge_unselected"),
                  UIImage(named: "concierge_selected"))
      case .commune:
          return (UIImage(named: "commune_unselected"),
                  UIImage(named: "commune_selected"))
      case .more:
          return (UIImage(named: "more_unselected"),
                  UIImage(named: "more_selected"))
    
      }
  }

  func createTabChildController() -> UIViewController {
      switch self {
      case .home:
          let homeVC = UIViewController.createController(storyBoard: .TabBar, ofType: DashboardViewController.self)
          return homeVC
      case .booking:
          let bookingVC = UIViewController.createController(storyBoard: .TabBar, ofType: BookingViewController.self)
          return bookingVC
      case .concierge:
          let conciergeVC = UIViewController.createController(storyBoard: .TabBar, ofType: ConciergeViewController.self)
          return conciergeVC
      case .commune:
          let communeVC = UIViewController.createController(storyBoard: .TabBar, ofType: CommuneViewController.self)
          return communeVC
      case .more:
         return UIViewController()
         
      }
  }

}
class TabBarButton: UIButton {
    private let iconImageView = UIImageView()
    private let backView = UIView()
    private let namelabel = UILabel()
    private var normalImage: UIImage?
    private var selectedImage: UIImage?
    private var normalFont = UIFont.systemFont(ofSize: 11)
    private var selectedFont = UIFont.boldSystemFont(ofSize: 11)
    private var normalColor: UIColor = .gray
    private var selectedColor: UIColor = .black
    override var isSelected: Bool {
        didSet {
            updateButtonAppearance()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    private func setupButton() {
        addSubview(self.backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.isUserInteractionEnabled = false
        // Configure icon image view
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.backView.addSubview(iconImageView)
        // Configure label
        namelabel.textAlignment = .center
        namelabel.translatesAutoresizingMaskIntoConstraints = false
        self.backView.addSubview(namelabel)
        // Set constraints
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backView.heightAnchor.constraint(equalToConstant: 60),
            backView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            backView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 35),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            namelabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 2),
            namelabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            namelabel.heightAnchor.constraint(equalToConstant: 20),
            namelabel.widthAnchor.constraint(equalTo: backView.widthAnchor),
        ])
    }
    func setIcon(_ icon: UIImage?) {
        iconImageView.image = icon
        normalImage = icon
    }
    func setSelectedIcon(_ icon: UIImage?) {
        selectedImage = icon
    }
    func setTitleName(_ title: String?, Font font: UIFont, Color txtColor: UIColor, SelectFont sFont: UIFont, SelectColor sColor: UIColor) {
        namelabel.text = title
        namelabel.font = font
        normalFont = font
        selectedFont = sFont
    }
    private func updateButtonAppearance() {
        self.backView.layer.cornerRadius = 25
        let image = normalImage
        if isSelected {
            backView.backgroundColor = UIColor.green.withAlphaComponent(0.2)
        } else  {
            backView.backgroundColor = UIColor.white
        }
        iconImageView.image = image
        namelabel.textColor = isSelected ? selectedColor : normalColor
        namelabel.font = isSelected ? selectedFont : normalFont
    }
}
