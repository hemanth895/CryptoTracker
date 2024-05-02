//
//  XMarkButton.swift
//  CryptoTracker
//
//  Created by hemanth on 4/30/24.
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
           presentationMode.wrappedValue.dismiss()
         }, label: {
        Image(systemName: "xmark")
         })
        
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton()
    }
}
