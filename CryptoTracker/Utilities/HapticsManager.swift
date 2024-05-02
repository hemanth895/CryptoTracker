//
//  HapticsManager.swift
//  CryptoTracker
//
//  Created by hemanth on 5/1/24.
//

import Foundation
import SwiftUI

class HapticsManager{
    
    static let generator = UINotificationFeedbackGenerator()
    
    
    static func notification(type:UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
