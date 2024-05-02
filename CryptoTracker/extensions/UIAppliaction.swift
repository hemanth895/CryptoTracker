//
//  UIAppliaction.swift
//  CryptoTracker
//
//  Created by hemanth on 4/30/24.
//

import Foundation
import SwiftUI


extension UIApplication{
    
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
