//
//  MembershipTabItem.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 25/07/24.
//

import Foundation
import UIKit

enum MembershipTabItem: Int, CaseIterable {
  case planType
  case agreementType
  case yourDetails
  case paymentDetails
  
  func getButtonTitle() -> String {
    switch self {
    case .planType:
      return "Plan Type"
    case .agreementType:
      return "Agreement Type"
    case .yourDetails:
      return "Your Details"
    case .paymentDetails:
      return "Payment Details"
    }
  }
  func getScreenTitle() -> String {
    switch self {
    case .planType:
      return "Choose Your Membership Plan"
    case .agreementType:
      return "Choose a plan | Save more with longe"
    case .yourDetails:
      return ""
    case .paymentDetails:
      return ""
    }
    
  }
  
  
  func createTabChildController() -> UIViewController {
    switch self {
    case .planType:
      let planTypeVC = UIViewController.createController(storyBoard: .Membership, ofType: PlanTypeViewController.self)
      return planTypeVC
    case .agreementType:
      let agreementTypeVC = UIViewController.createController(storyBoard: .Membership, ofType: AgreementViewController.self)
      return agreementTypeVC
    case .yourDetails:
      let yourDetailsVC = UIViewController.createController(storyBoard: .Membership, ofType: YourDetailsViewController.self)
      return yourDetailsVC
    case .paymentDetails:
      let paymentDetailsVC = UIViewController.createController(storyBoard: .Membership, ofType: PaymentDetailsViewController.self)
      return paymentDetailsVC
      
    }
  }
  
}
