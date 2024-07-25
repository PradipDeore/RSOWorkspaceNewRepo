//
//  PlanOptionList.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 25/07/24.
//

import Foundation

struct PlanOption {
    let title: String
    let mainDetails: String
    let subDetails: String
    let priceOptions: [String]
}

class PlanOptionList {
  static let shared = PlanOptionList()
  let options: [PlanOption] = [
      PlanOption(
          title: "Guest Desk Access",
          mainDetails: "One day access to open desk spaces",
          subDetails: "Secure WiFi, unlimited premium coffee & beverages included",
          priceOptions: [
              "From AED 11000.00 , unlimited",
              "From AED 31000.00 , 10 Days",
              "From AED 21000.00 , 5 Days"
          ]
      ),
      PlanOption(
          title: "Dedicated Desk",
          mainDetails: "Dedicated desk with storage",
          subDetails: "Secure WiFi, unlimited premium coffee & beverages included",
          priceOptions: [
              "From AED 21000.00 , monthly",
              "From AED 55000.00 , quarterly",
              "From AED 200000.00 , yearly",
              "From AED 65000.00 , quarterly",
              "From AED 750000.00 /pp, yearly"
          ]
      ),
      PlanOption(
          title: "Flexi Desk",
          mainDetails: "Flexi desk with storage",
          subDetails: "Secure WiFi, unlimited premium coffee & beverages included",
          priceOptions: [
              "From AED 15000.00 , unlimited",
              "From AED 40000.00 , quarterly",
              "From AED 150000.00 , yearly"
          ]
      )
  ]
  
}
