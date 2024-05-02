//
//  PortfolioDataService.swift
//  CryptoTracker
//
//  Created by hemanth on 5/1/24.
//

import Foundation
import CoreData



class PortfolioDataService{
    
    
    private let container : NSPersistentContainer
    
    
    private let containerName :String = "PortfolioContainer"
    
    
    private let entityName :String = "PortfolioEntity"
    
    
    @Published var savedEntities : [PortfolioEntity] = []
    
    
    init(){
        container = NSPersistentContainer(name:containerName)
        
        container.loadPersistentStores { (_,error) in
            if let error = error{
                print("Error Loading coredata \(error)")
            }
        }
        
        self.getPortfolio()
        
        
        
    }
    
    
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        
        do {
            savedEntities = try container.viewContext.fetch(request)
            
            
        }catch let error{
            print("error fetching portfgolio entities : \(error)")
        }
    }
    
    
    private func add(coin:CoinModel,amount:Double){
        
        
        let entity = PortfolioEntity(context: container.viewContext)
        
        entity.amount = amount
        entity.coinID = coin.id
        applyChanges()
        
        
    }
    
    
    private func save(){
        do{
            try container.viewContext.save()
        }catch let error{
            print("Error saving entities tp coredata : \(error)")
        }
    }
    
    
    private func applyChanges(){
        save()
        getPortfolio()
    }
    
    
    private func update(entity : PortfolioEntity,amount:Double){
        entity.amount = amount
        applyChanges()
    }
    
    
    private func delete(entity:PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    
    // MARK :- PUBLIC
    
    func updatePortfolio(coin:CoinModel,amount:Double){
        
        if let entity = savedEntities.first(where: { (savedentity) -> Bool in
            return savedentity.coinID == coin.id
        }){
            
            if amount > 0 {
                update(entity: entity, amount: amount)

            }else{
                delete(entity: entity)
            }
        }else{
            add(coin: coin, amount: amount)
        }
            
            
    }
    
    
}
