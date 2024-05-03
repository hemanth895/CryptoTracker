//
//  CoinDetailViewModel.swift
//  CryptoTracker
//
//  Created by hemanth on 5/2/24.
//

import Foundation
import Combine


class DetailViewModel : ObservableObject {
    
    
    private let coinDetailService : CoinDetailDataService
    
    private var cancellabels = Set<AnyCancellable>()
    
    
    @Published var coin : CoinModel
    @Published var overViewStatistics : [StatisticModel] = []
    @Published var additionalStatistics : [StatisticModel] = []
    
    
    @Published var coinDescription : String? = nil
    @Published var websiteUrl : String? = nil
    @Published var subredditUrl : String? = nil


     
    
    init (coin : CoinModel){
        
        self.coin = coin 
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
        
    }
    
    
    private func addSubscribers(){
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self](arrays) in

                self?.overViewStatistics = arrays.overview
                self?.additionalStatistics = arrays.additional
            }
            .store(in: &cancellabels)
        
        
        coinDetailService.$coinDetails
            .sink { [weak self] (coindetails) in
                self?.coinDescription = coindetails?.readableDescription
                self?.websiteUrl = coindetails?.links?.homepage?.first
                self?.subredditUrl = coindetails?.links?.subredditURL
            }
            .store(in: &cancellabels)
    }
    
    
    private func mapDataToStatistics(coinDetailModel:CoinDetailModel? , coinModel : CoinModel) -> (overview : [StatisticModel] , additional : [StatisticModel]){
        
        
        //over view stats
        let price = coinModel.currentPrice.asCurrencyWith6Decimal()
        let priceChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price , percentageChange: priceChange)
        
        let markertCap =  "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "market Capitalisation", value: markertCap , percentageChange : marketCapChange)
        
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        //overview array
        
        let overviewArray = [
        priceStat,
        marketCapStat,
        rankStat,
        volumeStat
        ]
        
        
        //additional stats array
        
        let high = coinModel.high24H?.asCurrencyWith6Decimal() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimal() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange2 = coinModel.priceChange24H?.asCurrencyWith2Decimal() ?? "n/a"
        let pricePercentChange2 = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange2,percentageChange: pricePercentChange2)
        
        let markerCapChange  = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: markerCapChange,percentageChange: marketCapPercentChange2)
        
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeINString = blockTime == 0 ? "n/a" : "\(blockTime)"
        
        
        let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeINString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        //additional stats array
        
        let AdditionalArray : [StatisticModel] = [
        highStat,
        lowStat,
        priceChangeStat,
        marketCapChangeStat,
        blockTimeStat,
        hashingStat
        ]
        
        
        return (overviewArray , AdditionalArray)
    }
}
