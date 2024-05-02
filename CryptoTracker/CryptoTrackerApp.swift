//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by hemanth on 4/29/24.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor : UIColor(Color.theme.accent)
        ]
        
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor : UIColor(Color.theme.accent)
        ]
    }
    
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
                    .environmentObject(vm)
                
            }
        }
    }
}
