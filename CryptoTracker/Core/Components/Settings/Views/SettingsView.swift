//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by hemanth on 5/3/24.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeUrl = URL(string: "https://www.youtube.com/c/swiftfulthinking")!
    let coffeUrl = URL(string: "https://www.buymeacoffr.com/nicksarno")!
    let coinGekoUrl = URL(string: "https://www.coingecko.com")!
    let personnalUrl = URL(string: "https://www.coingecko.com")!

    
    
    
    var body: some View {

        NavigationView {
            
            List {
            
                swiftfulthinkingSection
                coinGeckoSection
                developerSection
                applicationSection
            }


        }
        .listStyle(GroupedListStyle())
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                XMarkButton()
                
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


extension SettingsView{
    private var swiftfulthinkingSection : some View{
        Section(header: Text("Swiftfull Thinking")) {
            
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app is made by hemanth,uses coredata ,combine and mvvm artitecture")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Subscribe on Youtube 😒" ,destination: youtubeUrl)
            
            Link("Support hit  for coffe addiction 😒" ,destination: coffeUrl)
            
            
        }
        
    }
    
    
    private var coinGeckoSection : some View{
        Section(header: Text("Coin Gecko")) {
            
            VStack(alignment: .leading){
                Image("coingecko")
                    .resizable()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("The cryptocurrency for this app come from the coin gecko api ,price may slightly outdated")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("visit coingecko  😒" ,destination: coinGekoUrl)
            
            
            
        }
    }
    
    
    private var developerSection : some View{
        Section(header: Text("Developer")) {
            
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app was developed by hemanth ,it uses swiftUI and is written 100% in swift and combine")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("visit website  😒" ,destination: personnalUrl)
            
            
            
        }
        
    }
    
    private var applicationSection : some View{
        List{
            Section(header: Text("Application")) {
                
                Link("Terms of Service",destination: defaultURL)
                Link("Privacy Policy",destination: defaultURL)
                Link("Company Website",destination: defaultURL)
                Link("Learn More",destination: defaultURL)

            }
            
            
        }
        
    }
}
