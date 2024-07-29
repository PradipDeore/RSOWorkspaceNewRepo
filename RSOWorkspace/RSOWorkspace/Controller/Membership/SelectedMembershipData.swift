//
//  SelectedMembershipData.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 27/07/24.
//

import Foundation

class SelectedMembershipData {
    static let shared = SelectedMembershipData() // Singleton instance
    private init() {
      self.id = 0
      self.packageName = ""
      self.startDate = ""
      self.monthlyCost = ""
      self.agreementLength = 0
      self.planType = ""
    }
    var packageName: String
    var id: Int
    var startDate: String
    var agreementLength: Int
    var planType: String
    var monthlyCost: String
}
