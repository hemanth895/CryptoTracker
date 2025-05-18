//
//  File.swift
//  CryptoTracker
//
//  Created by hemanth on 4/30/24.
//

import Foundation
import Combine



class HomeViewModel:ObservableObject{
    
    @Published var altCoins : [CoinModel] = []
    
    @Published var portfolioCoins : [CoinModel] = []
    
    @Published var searchText : String = ""
    
    
    @Published var statistics : [StatisticModel] = []
    
    @Published var isLoading : Bool = false
    
    
    @Published var sortOption : SortOption = .holdings

    
    private let dataService = CoinDataService()
    private let marketDataService = MarketDataService()
    
    private let portfolioDataService = PortfolioDataService()

    
    private var cancellables = Set<AnyCancellable>()
    
    
    enum SortOption {
        case rank,rankReversed,holdings,holdingsReversed,price,priceReversed
    }

    
    init(){
      addSubcribers()
    }
    
    
    func addSubcribers(){
        dataService.$altcoin.sink { [weak self](coins) in
            self?.altCoins = coins
        }
        .store(in: &cancellables)
        
        $searchText
            .combineLatest(dataService.$altcoin,$sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
//            .map { [weak self] (text,startringCoins) -> [CoinModel] in
//
//               return self?.filterCoins(text: text, coins: startringCoins) ?? []
//
//            }
            .sink { [weak self](coins) in
                self?.altCoins = coins
            }
            .store(in: &cancellables)
        
        
        //updates the portfolio data

        $altCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (coins) in
                
                guard let self = self else {return}
                
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: coins)
            }
            .store(in: &cancellables)
        
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink {[weak self] (stats) in
                self?.statistics = stats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
    }
    
    
    func updatePortfolio(coin:CoinModel,amount:Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    
    private func filterAndSortCoins(text:String,coins:[CoinModel],sort: SortOption) -> [CoinModel]{
        
        var updatedCoins = filterCoins(text: text, coins: coins)
        
        sortCoins(sort: sort, coins: &updatedCoins)
        
//        let sortedCoins = sortCoins(sort: sort, coins: filteredCoins)
        
        return updatedCoins
    }
    
    private func filterCoins(text:String,coins:[CoinModel]) -> [CoinModel]{
            guard !text.isEmpty else{
                return coins
            }
            
            let lowercasedText = text.lowercased()
            return   coins.filter { (coin) -> Bool in
                return coin.name.lowercased().contains(lowercasedText) || coin.symbol.lowercased().contains(lowercasedText) || coin.id.lowercased().contains(lowercasedText)
            }
    }
    
    private func mapGlobalMarketData(marketData:MarketDataModel?,portfolioCoins:[CoinModel]) -> [StatisticModel]{
        var stats : [StatisticModel] = []
        
        guard let data = marketData else{
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap,percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        
        let BtcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map({$0.currentHoldingsValue})
            .reduce(0, +)
    
        let prevousValue = portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                let prevousvalue = currentValue / (1+percentChange)
                return prevousvalue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - prevousValue ) / prevousValue) * 100
        
        let portFolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimal(),percentageChange:percentageChange)

        
        stats.append(contentsOf: [
        marketCap,
        volume,
        BtcDominance,
        portFolio
        ])
        
        return stats

    }
    
    
    private func mapAllCoinsToPortfolioCoins(allcoins:[CoinModel],portfolioEntities:[PortfolioEntity])->[CoinModel]{
        allcoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id})else{return nil}
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    
    func reloadData(){
        isLoading = true
        dataService.getCoins()
        marketDataService.getCoins()
        HapticsManager.notification(type: .success)
    }
    
    
    private func sortCoins(sort:SortOption,coins:inout [CoinModel]){
        
        switch sort{
        case .rank ,.holdings:
            coins.sort(by: {$0.rank > $1.rank})

        case .rankReversed ,.holdingsReversed:
             coins.sort(by: {$0.rank > $1.rank})
            
        case .price:
             coins.sort(by: {$0.currentPrice < $1.currentPrice})

        case .priceReversed:
             coins.sort(by: {$0.currentPrice > $1.currentPrice})
        }
    }
    
    
    private func sortPortfolioCoinsIfNeeded(coins:[CoinModel])->[CoinModel]{
        switch sortOption{
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
            
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
            
        default:
            return coins

        }
    }
}
