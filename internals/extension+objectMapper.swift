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
open class DataTransformBase64: TransformType {
    
    public typealias Object = Data
    public typealias JSON = String
    public init() {}
    
    
    public func transformFromJSON(_ value: Any?) -> Data? {
        if let  dataBase64 = value as? String{
            
            return  Data.init(base64Encoded: dataBase64)
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

// YYYY-MM 日期转换
open class YearMonthtDateTransform: TransformType {
    
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





