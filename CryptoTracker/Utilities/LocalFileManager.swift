//
//  LocalFileManager.swift
//  CryptoTracker
//
//  Created by hemanth on 4/30/24.
//

import Foundation
import SwiftUI


class LocalFileManager {
    static let instance = LocalFileManager()
    
    private init(){}
    
    
    func saveImage(image:UIImage,imageName:String,folderName:String){
        
        createFolderIfNeeded(folderName: folderName)
        
        guard let data = image.pngData(),
        let url = getURLForImage(imageName: imageName, folderName: folderName)
        else {return}
        
        
        do {
            try data.write(to:url)

        }catch let error{
            print("error saving image.  \(imageName)  \(error)")
        }
        
    }
    
    
    func getImage(imageName:String,folderName:String) -> UIImage?{
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),FileManager.default.fileExists(atPath: url.path) else{
            return nil
        }
        
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName:String){
        guard let url = getUrlForFolder(folderName: folderName) else{
            return
        }
        
        if !FileManager.default.fileExists(atPath: url.path){
            do{
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true,attributes: nil)
            }catch let error{
                print("Error creating directory. \(folderName)  ..\(error)")
            }
            
        }
    }
    
    
    private func getUrlForFolder(folderName:String)->URL?{
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        return url.appendingPathComponent(folderName)
        
        
    }
    
    
    private func getURLForImage(imageName:String,folderName:String) -> URL? {
        guard let folderUrl = getUrlForFolder(folderName: folderName) else {
            return nil
        }
        
        return folderUrl.appendingPathComponent(imageName + ".png")
    }
}
