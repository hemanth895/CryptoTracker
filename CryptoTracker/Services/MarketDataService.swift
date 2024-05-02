//
//  MarketDataService.swift
//  CryptoTracker
//
//  Created by hemanth on 4/30/24.
//

import Foundation
import Combine


class MarketDataService{
    
    @Published  var marketData : MarketDataModel? = nil
    
//    var cancellabels = Set<AnyCancellable>()
    
    var marketDataSubscription : AnyCancellable?
    
    
    init (){
        getCoins()
    }
    
     func getCoins(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink { (completion) in
                NetworkingManager.handleCompletion(completion: completion)
            } receiveValue: { [weak self](data) in
                
                self?.marketData = data.data
                self?.marketDataSubscription?.cancel()
            }

    }
}

