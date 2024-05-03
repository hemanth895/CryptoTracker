//
//  String.swift
//  CryptoTracker
//
//  Created by hemanth on 5/3/24.
//

import Foundation


extension String{
    
    var removingHTMLOccurances : String{
        return self.replacingOccurrences(of: "<[^>]+>", with: "",options: .regularExpression,range: nil)
    }
}
