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



// 成为观察者
extension Reactive where Base: UILabel{
    
    var rxob: Binder<Result>{
        return Binder.init(self.base){ (label, v) in
            
                label.textColor = v.textColor
                label.text = v.describtion
                
            }
    }
    
}

extension Reactive where Base: UIScrollView{
    
    var rxob: Binder<ItemLayout>{
        return Binder.init(self.base){
            (sc,ly) in
            switch ly{
            case let .RotateImageLayout(images, width, height):
               print("")
            }
           
           
    }
}
}


extension Reactive where Base: UIButton{
    
    var rxob: Binder<Result>{
        return Binder.init(self.base, binding: { (button, v) in
            button.isEnabled = v.validate
            button.alpha = v.validate ? 1: 0.5
        })
    }
}


extension ObservableConvertibleType{
    public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<E> {
        return activityIndicator.trackActivityOfObservable(self)
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
    
    // 将Json解析为多个Model，返回数组，对于不同的json格式需要对该方法进行修改
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
    // 将Json解析为Observable<[Model]>
    public func mapArray<T: BaseMappable>(_ type: T.Type,tag:String) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(T.self,tag: tag))
        }
    }
    
}

