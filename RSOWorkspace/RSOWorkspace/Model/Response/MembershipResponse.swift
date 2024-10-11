//
//  MembershipResponse.swift
//  RSOWorkspace
//
//  Created by Pradip Deore on 27/07/24.

import Foundation

// MARK: - Welcome
struct MembershipResponse: Codable {
    let error: String?
    let status: StatusType?
    let data: [MembershipData]?
    let message:String?
    
}


// MARK: - Datum
struct MembershipData: Codable {
    let id: Int?
    let name: String?
    let orderBy: Int?
    let services: [String]?
    let price: [PlanPrice]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case orderBy = "order_by"
        case services, price
    }
}

extension MembershipData {
    // Function to get a list of distinct PlanPrice based on duration
    func getDistinctPlanPriceList() -> [PlanPrice] {
        // Use a Set to track unique durations and a higher-order function to filter distinct prices
        var seenDurations = Set<String>()
      let distinctPlanPrices = price?.filter { planPrice in
            guard let duration = planPrice.duration else { return false }
            if seenDurations.contains(duration) {
                return false
            } else {
                seenDurations.insert(duration)
                return true
            }
        } ?? []
      return distinctPlanPrices
    }
    
    // Function to get PlanPrice list matching a specific duration
    func matchingPlanPriceList(for duration: String) -> [PlanPrice] {
      let matchingPlans = price?.filter { $0.duration == duration } ?? []
      let sortedPlanPrices = matchingPlans.sorted(by: { ($0.length ?? 0) < ($1.length ?? 0) })
      return sortedPlanPrices

    }
}

// MARK: - Price
struct PlanPrice: Codable {
    let price: String?
    let duration: String?
    let length: Int?
    let per_person_text:String?
}
