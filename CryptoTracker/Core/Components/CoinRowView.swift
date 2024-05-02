//
//  CoinRowView.swift
//  CryptoTracker
//
//  Created by hemanth on 4/29/24.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin:CoinModel
    
    let showHoldingsColumn:Bool
    
    var body: some View {
        

        HStack(spacing: 0){
            
           leftColumnn
            
            Spacer()
            
            if showHoldingsColumn{
                centerColumn
            }
            
            Spacer()
            
            rightColumn
          
            
        }
        .font(.subheadline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group{
            CoinRowView(coin: dev.coin,showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
            
            
            CoinRowView(coin: dev.coin,showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            
            CoinRowView(coin: dev.coin,showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
            
        }
    }
}


extension CoinRowView{
    
    
    private var leftColumnn:some View{
        HStack(spacing: 0){
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.SecondaryText)
                .frame(minWidth: 30)
            
            CoinImageView(coin: coin)
                .frame(width: 30,height: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    
    private var centerColumn:some View{
        VStack(alignment: .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith6Decimal())
            Text((coin.currentHoldingsValue ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)

    }
    
    
    private var rightColumn:some View{
        VStack(alignment: .trailing){
            Text(coin.currentPrice.asCurrencyWith6Decimal())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "0.00%")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                    Color.theme.green
                    : Color.theme.red
                )
            
        }
        .frame(width: UIScreen.main.bounds.width / 3.5,alignment: .trailing)
    }
}
