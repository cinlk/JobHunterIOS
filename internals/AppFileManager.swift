//
//  FileMangers.swift
//  internals
//
//  Created by ke.liang on 2018/3/31.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation


fileprivate let imageDir = "images"

class AppFileManager{
    
    
    static let shared = AppFileManager()
    
    
    private var imagePath:String = ""
    
    private init(){
        initialImageDir()
    }
    
    
    private func initialImageDir(){
        
        // 在document里创建images目录
        let url = SingletoneClass.fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        if  let imagepath = url.last?.appendingPathComponent(imageDir){
            let exist = SingletoneClass.fileManager.fileExists(atPath: imagepath.path)
            imagePath = imagepath.path
            
           if exist == false{
                do{
                    try  SingletoneClass.fileManager.createDirectory(atPath: imagepath.path, withIntermediateDirectories: true, attributes: nil)
                }catch{
                    print(error)
                }
            }
        }
        
        
    }
    
    open func createImageFile(userID:String, fileName:String, image:Data) throws {
        // 用户子文件夹判断
        let userDir = imagePath + "/" + userID
        if  SingletoneClass.fileManager.fileExists(atPath: userDir) == false{
            do{
                try  SingletoneClass.fileManager.createDirectory(atPath: userDir, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print(error)
            }
        }
        
        // 存储的文件路径
        let path = userDir + "/" + fileName
        do{
           
            try image.write(to: URL.init(fileURLWithPath: path), options: Data.WritingOptions.fileProtectionMask)
        }catch{
            print(error)
            throw error
        }
    }
    
    open func deleteImagewith(userID:String,  fileName:String){
        let path =   imagePath + "/" + userID + "/" + fileName
        do{
            
            try SingletoneClass.fileManager.removeItem(atPath: path)
        }catch{
            print(error)
        }
    }
    
    // 清楚该用户下所有image
    open func deleteDirBy(userID:String){
        let userPath = imagePath + "/" + userID
        do{
            if SingletoneClass.fileManager.fileExists(atPath: userPath){
                try SingletoneClass.fileManager.removeItem(atPath: userPath)
            }
        }catch{
            print(error)
        }
    }
    
    open func getImageDataBy(userID:String, fileName:String) -> Data?{
        let path = imagePath + "/" + userID + "/" +  fileName
        do{
            if SingletoneClass.fileManager.fileExists(atPath: path){
                return  try Data.init(contentsOf: URL.init(fileURLWithPath: path))
            }
        }catch{
            print(error)
        }
        
        return nil
        
    }
    
    
    
    
}
