//
//  CoinImageViewModel.swift
//  CryptoTracker
//
//  Created by hemanth on 4/30/24.
//

import Foundation
import SwiftUI
import Combine


class CoinImageViewModel : ObservableObject {
    
    @Published var image : UIImage?
    @Published var isLoading : Bool = false
    
    private let coin : CoinModel?
    private let dataService : CoinImageService
    private var cancellable = Set<AnyCancellable>()
    
    init(coin:CoinModel){
        
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        
        addSubscribers()
        
        self.isLoading = true
    }
    
    private func addSubscribers(){
        
        dataService.$image
            .sink {[weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (image) in
                self?.image = image
            }
            .store(in: &cancellable)

        
    }
}
