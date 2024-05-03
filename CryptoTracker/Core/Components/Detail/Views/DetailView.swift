//
//  DetailView.swift
//  CryptoTracker
//
//  Created by hemanth on 5/2/24.
//

import SwiftUI

struct DetailLoadingView : View{
    
    @Binding var coin : CoinModel?
    
    
    var body: some View {
        
        
        ZStack{
            
            if let coin = coin{

                DetailView(coin: coin)
            }
        }
        
        
    }
}

struct DetailView: View {
    
    let  coin : CoinModel
    
    @StateObject private var vm  : DetailViewModel
    
    @State private var showfullDescription : Bool = false
    
    private let columns:[GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),

        
    ]
    
    private var spacing : CGFloat = 30

    
    init(coin: CoinModel) {
        self.coin = coin
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        
    }
    
    var body : some View{

        ScrollView{
            
            
            VStack{
                
                ChartView(coin: coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    
                    overviewTitle
                    Divider()
                    descriptionSection
                    overViewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    websiteSection
                    
                    
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
               naviagtionTrainlingItems
            }
        }
    }
    
 
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}



extension DetailView{
    
    private var overviewTitle : some View{
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    
    private var additionalTitle  : some View{
        Text("Additinal Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var overViewGrid :some View{
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {

                ForEach(vm.overViewStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
            )
    }
    
    private var additionalGrid :some View{
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {

                ForEach(vm.additionalStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
            )
    }
    
    
    
    
    private var naviagtionTrainlingItems: some View{
        HStack{
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.SecondaryText)
            
            CoinImageView(coin : vm.coin)
                .frame(width: 25,height: 25)
        }
    }
    
    
    private var descriptionSection : some View{
        ZStack{
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty{
                
                
                VStack(alignment: .leading){
                    Text(coinDescription)
                        .lineLimit(showfullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.SecondaryText)
                    
                    Button {
                        withAnimation(.easeInOut){
                            showfullDescription.toggle()
                        }
                    } label: {
                        Text(showfullDescription ? "Show Less" : "Read More...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical,4)
                    }

                }
                .frame(maxWidth: .infinity,alignment: .leading)
                
            }
        }
    }
    
    private var websiteSection : some View {
        
        ZStack{
            
            VStack{
                if let websiteString = vm.websiteUrl,
                   let url = URL(string: websiteString){
                    Link("website", destination: url)
                }
                
                if let reddditString = vm.subredditUrl,
                   let subredditurl = URL(string: reddditString){
                    Link("Reddit", destination: subredditurl)
                }
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity,alignment:.leading)
        .font(.headline)
    }
}
