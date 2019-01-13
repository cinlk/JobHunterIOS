//
//  BaseNetworkTool.swift
//  internals
//
//  Created by ke.liang on 2019/1/11.
//  Copyright © 2019 lk. All rights reserved.
//


import Moya
import Alamofire

public enum GlobaHttpRequest {
    
    case guideData
    case helloMsg
    case adviseImages
    case userlogin(account:String, password:String)
    case setHelloMsg(index:Int)
    
    
}



extension GlobaHttpRequest: TargetType{
    
    
    
    public var baseURL: URL {
        
        return URL.init(string: GlobalConfig.BASE_URL)!
    }
    
    public var path: String {
        switch self {
        case .guideData:
            return "guides"
        case .helloMsg:
            return  "hellos"
        case .adviseImages:
            return "advise"
        case .userlogin:
            return "login"
        case .setHelloMsg:
            return "hellos"
        }
    }
    
    public  var method: Moya.Method {
        switch self {
        case .guideData, .adviseImages, .helloMsg:
            return .get
        case .userlogin:
            return .post
        case .setHelloMsg:
            return .put
        }
    }
        
    
    public var sampleData: Data {
        return "".utf8Encoded
    }
    
    public var task: Task {
        switch self {
        case .guideData, .helloMsg, .adviseImages:
            return Task.requestPlain
        case let .userlogin(account, password):
            
            return .requestParameters(parameters: ["account":account, "password":password], encoding: JSONEncoding.default)
        case let .setHelloMsg(index):
            return Task.requestParameters(parameters: ["count":index], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}



class NetworkTool {
    
    

 
    
    static var timeout: Double = 30
    
    
    
    static let httpRequest = MoyaProvider<GlobaHttpRequest>.init(endpointClosure: { (target) -> Endpoint in
        let url = target.baseURL.absoluteString + target.path
        var endpoint = Endpoint.init(
            url: url,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
        switch target{
            
        case .guideData, .adviseImages:
            
            timeout = 10
        case .helloMsg, .userlogin:
            timeout = 30
        case .setHelloMsg(let index):
            timeout = 30
        }
        
        return endpoint
        
    }, requestClosure: { (endpoint, done) in
        do{
            
            
            
            var req = try endpoint.urlRequest()
            req.timeoutInterval = timeout
            if let reqData = req.httpBody{
                print("\(req.url!)"+"\n"+"\(req.httpMethod ?? "")"+"发送参数"+"\(String(data: req.httpBody!, encoding: String.Encoding.utf8) ?? "")")
            }else{
                print("\(req.url!)"+"\(String(describing: req.httpMethod))")
            }
            
            done(.success(req))
        }catch{
            
            //done()
            done(.failure(MoyaError.underlying(error, nil)))
            
        }
        
    }, plugins: [NetworkActivityPlugin.init { (changeType, targetType) in
        
        print("networkPlugin \(changeType)")
        //targetType 是当前请求的基本信息
        switch(changeType){
        case .began:
            print("开始请求网络")
            
        case .ended:
            print("结束")
        }
        }], trackInflights: false)
    
        //MoyaProvider<GlobaHttpRequest>.init()
    
    class func request(_ target: GlobaHttpRequest,
                       successCallback: @escaping (Any) -> Void,
                       failureCallback: @escaping (MoyaError)->Void){
        
        
        httpRequest.request(target){ result in
            switch result {
            case let .success(response):
             
                do{
                    
                    _ =  try  response.filterSuccessfulStatusCodes()
                    let json =  try response.mapJSON(failsOnEmptyData: true)
                    successCallback(json)
                    
                }catch let error{
                    failureCallback(error as! MoyaError)
                }
            case let .failure(error):
                failureCallback(error)
            }
        }
        
    }
    
    
    
}





















