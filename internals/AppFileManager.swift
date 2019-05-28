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
    
    open func createImageFile(userID:String, fileName:String, image:Data, complete: @escaping ((_ success:Bool, _ err:Error?)->Void)) throws {
        // 用户子文件夹判断
        let userDir = imagePath + "/" + userID
        if  SingletoneClass.fileManager.fileExists(atPath: userDir) == false{
            do{
                try  SingletoneClass.fileManager.createDirectory(atPath: userDir, withIntermediateDirectories: true, attributes: nil)
            }catch{
                complete(false, error)
                throw error
            }
        }
        
        // 存储的文件路径
        let path = userDir + "/" + fileName
        do{
           
            try image.write(to: URL.init(fileURLWithPath: path), options: Data.WritingOptions.fileProtectionMask)
            complete(true, nil)
        }catch{
            complete(false, error)
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
    open func deleteDirBy(conversationId:String) throws {
        let userPath = imagePath + "/" + conversationId
        do{
            if SingletoneClass.fileManager.fileExists(atPath: userPath){
                try SingletoneClass.fileManager.removeItem(atPath: userPath)
            }
        }catch{
            throw error 
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
    
    
    // 获取缓存文件大小
    func fileSizeOfCache() -> Int{
        guard let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask,   true).first else {
            return 0
        }
        //print(cachePath)
        
        guard let fileArr = SingletoneClass.fileManager.subpaths(atPath: cachePath) else {
            return 0
        }

        var size:Int = 0
        for file in fileArr{
            let path = cachePath +  "/\(file)"
            
            let floder = try! SingletoneClass.fileManager.attributesOfItem(atPath: path)
            for (att, any) in floder{
                if att == FileAttributeKey.size{
                  size += (any as AnyObject).integerValue
                
                }
            }
            
        }
        
        return size / 1024 / 1024
    }
    
    
    func deleteCache() throws{
        
        
        let library = SingletoneClass.fileManager.urls(for: FileManager.SearchPathDirectory.libraryDirectory, in: .userDomainMask)[0]
        let dir = library.appendingPathComponent("Caches")
        let contents = try SingletoneClass.fileManager.contentsOfDirectory(atPath: dir.path)
        
        for content in contents {
            //如果是快照就继续
            
            if(content == "Snapshots"){continue;}
            if SingletoneClass.fileManager.fileExists(atPath: dir.appendingPathComponent(content).absoluteString){
                 try SingletoneClass.fileManager.removeItem(atPath:  dir.appendingPathComponent(content).absoluteString)
            }
           
//            do {
//
//                //print("remove cache success:"+content)
//            } catch where ((error as NSError).userInfo[NSUnderlyingErrorKey] as? NSError)?.code == Int(EPERM) {
//                //print("remove cache error:"+content)
//                // "EPERM: operation is not permitted". We ignore this.
//               // #if DEBUG
//                //print("Couldn't delete some library contents.")
//               // #endif
//            }
        }
            
    }
    
    
}
