//
//  extension+objectMapper.swift
//  internals
//
//  Created by ke.liang on 2018/3/27.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation


//
//  DateTransform.swift
//  ObjectMapper
//
//  Created by Tristan Himmelman on 2014-10-13.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014-2016 Hearst
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import ObjectMapper

// data 和 base64string 相互转换
final class DataTransformBase64: TransformType {
    
    public typealias Object = Data
    public typealias JSON = String
    public init() {}
    
    
    public func transformFromJSON(_ value: Any?) -> Data? {
        // 转换为base64
        if let  content = value as? String, let base64content = content.data(using: String.Encoding.utf8)?.base64EncodedString(){
            return  Data.init(base64Encoded: base64content)
        }
        if let data = value as? Data{
            return data
        }
        
        return nil
    }
    
    public func transformToJSON(_ value: Data?) -> String? {
        if let data = value{
           return data.base64EncodedString()
        }
        return nil
    }
}

final class DefaultValueTransform: TransformType {
    
    typealias Object = String
    
    typealias JSON = String
    
    private let defaultValue:String
    
    public init(defaultValue:String) {
        self.defaultValue = defaultValue
    }
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let str = value as? String, !str.isEmpty{
            return str
        }
        
        return self.defaultValue
    }
    
    public func transformToJSON(_ value: Object?) -> JSON? {
        if let data = value{
            return data
        }
        return nil
    }
    
}

//final class ForumTypeTransform: TransformType {
//    
//    typealias Object =  ForumType
//    
//    typealias JSON = String
//    
//    public func transformFromJSON(_ value: Any?) -> ForumType? {
//        if let t = value as? String{
//            return ForumType(rawValue: t)
//        }
//        
//        return nil
//    }
//    
//    public func transformToJSON(_ value: ForumType?) -> String? {
//        if let t = value{
//            return t.describe
//        }
//        
//        return nil
//    }
//}

// YYYY-MM 日期转换
final class YearMonthtDateTransform: TransformType {
    
    public typealias Object = Date
    public typealias JSON = String
    let dateformat = DateFormatter()

    public func transformFromJSON(_ value: Any?) -> Date? {
        if let YearAnMonth = value as? String{
            dateformat.locale = Locale.current
            dateformat.dateFormat = "YYYY-MM"
            
            return  dateformat.date(from: YearAnMonth)
        }
        return nil
    }
    
    public func transformToJSON(_ value: Date?) -> String? {
        if let date = value{
            dateformat.locale = Locale.current
            dateformat.dateFormat = "YYYY-MM"
            return dateformat.string(from: date)
        }
        return nil
    }
}


// object <==> json
final class JsonObjectTransform<T>: TransformType where T: Mappable {
    
    
    public typealias Object = T
    
    public typealias JSON = [String:Any]
    
    
    func transformFromJSON(_ value: Any?) -> Object? {
        // 数组类型
        
        
        if let json = value as? [String:Any]{
            
            return Mapper<T>().map(JSON: json)
        }
      
        
        return nil
    }
    
    func transformToJSON(_ value: T?) -> JSON? {
        if let map = value {
            return map.toJSON()
        }
        return nil
    }
    
    
}

// object == json array


final class JsonArrayObjectTransform<T>: TransformType where T: Mappable {
    
    
    public typealias Object = [T]
    
    public typealias JSON = [[String:Any]]
    
    
    func transformFromJSON(_ value: Any?) -> Object? {
        // 数组类型
        
        
        if let json = value as? [[String:Any]]{
            
            return Mapper<T>().mapArray(JSONObject: json)
        }
        
        
        return nil
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        
        if let map = value {
            var res:[[String:Any]] = []
            map.forEach { (m) in
                res.append(m.toJSON())
            }
            return  res 
        }
        return nil
    }
    
    
}




