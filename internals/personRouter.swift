//
//  personRouter.swift
//  internals
//
//  Created by ke.liang on 2018/3/5.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation



fileprivate let appDomain:String = "lk:"




//class URLObj{
//    
//    enum  categoryType:String {
//        case cell
//        case vc
//        case view
//        case none
//        
//        var st: String{
//            get{
//                switch self {
//                case .cell:
//                    return "cell"
//                case .vc:
//                    return "vc"
//                case .view:
//                    return "view"
//                default:
//                    return "none"
//                }
//            }
//        }
//    }
//    
//    private var schema:String
//    
//    private var type:categoryType
//    
//    private var viewName:String
//    
//    private var parameters:Dictionary<String,String>
//    
//    init(shema:String, type:categoryType, viewName:String, parameters:Dictionary<String,String>) {
//        self.schema = shema
//        self.type = type
//        self.viewName = viewName
//        self.parameters = parameters
//    }
//    
//    open func urlString()->String{
//        
//        var st = ""
//        for (k, v) in parameters{
//            st = k + "=" + v
//        }
//        if !parameters.isEmpty{
//            
//        }
//        return appDomain + ":" + type.st + ":/" + viewName + "/" + st
//        
//        
//    }
//}
//
//// 页面跳转之间路由，解耦页面直接关联
//class PersonRouter{
//    
//    
//     // 第一个域名
//    private var urldomain:String?
//    
//    private var VCname:String?
//    
//    private var VCClass:Any?
//    
//    // 建立 vcname 和vcclass 配对
//    
//    // url 传入的参数
//    private var vcparameter:Dictionary<String,Any>?
//    private var urls:[URLObj] = [] 
//    static let shared:PersonRouter = PersonRouter.init()
//    private init() {
//        map()
//    }
//    
//    
//    // 设置规则
//    open func map(){
//        let cell =  URLObj.init(shema: "<#T##String#>", type: <#T##URLObj.categoryType#>, viewName: <#T##String#>, parameters: <#T##Dictionary<String, String>#>)
//    }
//    
//    // 根据规则路由界面
//    open func routerVCClass()->UIViewController{
//        
//    }
//    
//    open func routerCellClass()->UITableViewCell{
//        
//    }
//    
//    
//    
//}

