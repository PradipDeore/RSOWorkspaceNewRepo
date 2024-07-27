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
      return "1. Plan Type"
    case .agreementType:
      return "2. Agreement Type"
    case .yourDetails:
      return "3. Your Details"
    case .paymentDetails:
      return "4. Payment Details"
    }
  }
  func getScreenTitle() -> String {
    switch self {
    case .planType:
      return "Choose Your Membership Plan"
    case .agreementType:
      return "Choose Agreement Type"
    case .yourDetails:
      return "Create your RSO Account"
    case .paymentDetails:
      return "Payment Details"
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
