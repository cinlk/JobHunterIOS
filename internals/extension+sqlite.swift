//
//  extension+sqlite.swift
//  internals
//
//  Created by ke.liang on 2018/3/25.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation

import SQLite

extension NSData: Value {
    
    // SQL Type
    public class var declaredDatatype: String {
        return Blob.declaredDatatype
    }
    
    // Decode
    public class func fromDatatypeValue(_ datatypeValue: Blob) -> NSData {
        return NSData(bytes: datatypeValue.bytes, length: datatypeValue.bytes.count)

        
    }
    
    // Encode
    public var datatypeValue: Blob {
        return Blob(bytes: self.bytes, length: self.length)
    }
}

extension UIImage: Value {
    
    // Decode
    public class func fromDatatypeValue(_ datatypeValue: Blob) -> UIImage {
        return UIImage(data: NSData.fromDatatypeValue(datatypeValue) as Data)!
    }
    
    
    // SQL Type
    public class var declaredDatatype: String {
        return NSData.declaredDatatype
    }
    
    // Decode
//    public class func fromDatatypeValue(datatypeValue: Blob) -> UIImage? {
//
//    }
    
    // Encode
    public var datatypeValue: Blob {
        
        return self.pngData()!.datatypeValue
    }
}
