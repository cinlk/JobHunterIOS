//
//  extension+observer.swift
//  internals
//
//  Created by ke.liang on 2017/11/18.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
import ObjectMapper




extension Reactive where Base: UIScrollView{
    
    var rxob: Binder<ItemLayout>{
        return Binder.init(self.base){_,_ in 
//            (sc,ly) in
//            switch ly{
//            case let .RotateImageLayout(images, width, height):
//               print("")
//            }
           
           
    }
}
}




extension Reactive where Base: UIButton {
    var rxEnable: Binder<Bool>{
        return Binder.init(self.base, binding: { (btn, r) in
            btn.isEnabled = r
            btn.alpha = r ? 1 : 0.5
            
        })
    }
}



extension Reactive where Base: SearchTypeMenuView{
    
    var hidden: Binder<Bool>{
        return Binder.init(self.base, binding: { (target, v) in
            let t =  target as SearchTypeMenuView
            if v == true{
                t.dismiss()
            }
        })
    }
}
extension Reactive where Base: SearchRecordeViewController{
    var status: Binder<String>{
        return Binder.init(self.base, binding: { (target, v) in
            let t =  target as SearchRecordeViewController
            t.showHistoryTable = v.isEmpty
            // 显示搜索历史界面
            
        })
    }
}






extension Response {
    // 将Json解析为单个Model
    public func mapObject<T: BaseMappable>(_ type: T.Type) throws -> T {
        guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }
    
    public func mapObject<T: BaseMappable>(_ type: T.Type, tag: String) throws -> T{
        guard let json = try mapJSON() as? [String: Any] else {
            throw MoyaError.jsonMapping(self)
        }
        
        guard  let subJson = json[tag]  as? [String: Any] else {
            throw MoyaError.jsonMapping(self)
        }
        guard  let object =  Mapper<T>().map(JSON: subJson) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }
    
    // 将Json解析为多个Model，返回数组，对于不同的json格式需要对该方法进行修改
//    {
//    "tag_name":[
//    {},
//    {},
//    ]
//
//    }
    public func mapArray<T:BaseMappable>(_ type: T.Type,tag:String) throws -> [T] {
        
        guard let json = try mapJSON() as? [String : Any] else {
            throw MoyaError.jsonMapping(self)
        }
        // 获取指定tag 的json 数据
        guard let jsonArr = (json[tag] as? [[String : Any]]) else {
            throw MoyaError.jsonMapping(self)
        }
        
        return Mapper<T>().mapArray(JSONArray: jsonArr)
    }
    
    
}


extension ObservableType where E == Response {
    
    // 将Json解析为Observable<Model>
    public func mapObject<T: BaseMappable>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(T.self))
        }
    }
    public func mapObject<T: BaseMappable>(_ type:T.Type, tag:String) -> Observable<T>{
        
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(T.self, tag: tag))
        }
        
    }
    // 将Json解析为Observable<[Model]>
    public func mapArray<T: BaseMappable>(_ type: T.Type,tag:String) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(T.self,tag: tag))
        }
    }
    
    
    
}

