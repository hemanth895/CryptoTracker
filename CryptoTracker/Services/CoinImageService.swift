//
//  CoinImageService.swift
//  CryptoTracker
//
//  Created by hemanth on 4/30/24.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image : UIImage?
    
    private var imageSubscription : AnyCancellable?
    
    private let coin : CoinModel
    
    private let fileManger = LocalFileManager.instance
    
    private let folderName = "coin_images"
    private let image_name : String
    
    init(coin:CoinModel){
        self.coin = coin
        self.image_name = coin.id
        
//        downloadCoinImage()
        
        getCoinImage()
    }
    
    
    private func getCoinImage(){
        if let savedImage = fileManger.getImage(imageName: coin.id, folderName: folderName){
            image = savedImage
            print("retrivng image from file Storage")
        }else{
            downloadCoinImage()
            print("downloadinng the files")
        }
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink { (completion) in
                NetworkingManager.handleCompletion(completion: completion)
            } receiveValue: { [weak self](image) in
                
                guard let self = self ,let downloadedImage = image else {return}

                self.image = image
                self.imageSubscription?.cancel()
                self.fileManger.saveImage(image: downloadedImage, imageName: image_name, folderName: folderName)
            }
    }
}
