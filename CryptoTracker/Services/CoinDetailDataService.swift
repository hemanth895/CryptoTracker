//
//  CoinDetailDataService.swift
//  CryptoTracker
//
//  Created by hemanth on 5/2/24.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    
    @Published  var coinDetails : CoinDetailModel? = nil
    
//    var cancellabels = Set<AnyCancellable>()
    
    var coinDetailSubscription : AnyCancellable?
    
    let coin : CoinModel
    
    
    init (coin:CoinModel){
        
        self.coin = coin
        getCoinDetails(id:coin.id)
    }
    
    func getCoinDetails(id:String){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink { (completion) in
                NetworkingManager.handleCompletion(completion: completion)
            } receiveValue: { [weak self](details) in
                
                print(details)
                self?.coinDetails = details
                self?.coinDetailSubscription?.cancel()
            }

    }
}
