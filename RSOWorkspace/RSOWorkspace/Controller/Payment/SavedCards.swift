//
//  SavedCards.swift
//  RSOWorkspace
//
//  Created by Sumit Aquil on 02/08/24.
//

import Foundation


class CardListManager {
    static let shared = CardListManager()
    private init() {
    }
    var cards: [GetCardDetails] = []
  
    
    
    func getCardDetails() {
            APIManager.shared.request(
                modelType: GetCardDetailsResponseModel.self,
                type: PaymentMethodEndPoint.getCardDetail) { response in
                    switch response {
                    case .success(let response):
                        DispatchQueue.main.async {
                            self.cards = response.data?.filter { cardDetail in
                                guard let number = cardDetail.number, !number.isEmpty else {
                                    return false
                                }
                                ("get card details respone",self.cards)
                                return true
                            } ?? []
                        }
                    case .failure(let error):
                        print("getCardDetails error")
                    }
                }
        }
   
}
