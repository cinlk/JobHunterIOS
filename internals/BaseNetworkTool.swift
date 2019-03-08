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
    case userlogin(phone:String, password:String)
    case logout
    case setHelloMsg(index:Int)
    // 获取新闻栏目数据
    case news(type:String, offset:Int)
    // 周边宣讲会
    case nearByMeetings(latitude: Double, longitude: Double, distance: Double)
    // 周边公司
    case nearyByCompany(latitude: Double, longtitude: Double, distance: Double)
    // 选择的城市
    case citys
    case bussinessField
    // 细化的行业职位
    case subBusinessField
    // 公司选择类型
    case companyType
    // 实习选择类型
    case internCondition
    // 城市大学
    case cityCollege
    // 职位举报信息
    case jobWarns
    
    
    
}



extension GlobaHttpRequest: TargetType{
    
    private var urlPrefix:String {
        return "global/"
    }
    
    public var baseURL: URL {
        
        return URL.init(string: GlobalConfig.BASE_URL)!
    }
    
    public var path: String {
        switch self {
        case .guideData:
            return self.urlPrefix + "guidance"
        case .helloMsg:
            return self.urlPrefix + "hellos"
        case .adviseImages:
            return self.urlPrefix + "advise/image"
        case .userlogin:
            return   "account/login/pwd"
        case .logout:
            return  "account/logout"
        case .setHelloMsg:
            return self.urlPrefix + "hellos"
        case .news(_, _):
            return self.urlPrefix + "news"
        case .nearByMeetings:
            return "home" + "/near/meetings"
        case .nearyByCompany:
            return "home" + "/near/company"
        case .citys:
            return self.urlPrefix + "citys"
        case .bussinessField:
            return self.urlPrefix + "business/field"
        case .subBusinessField:
            return self.urlPrefix + "subBusiness/field"
        case .companyType:
            return self.urlPrefix + "company/type"
        case .internCondition:
            return self.urlPrefix + "intern/condition"
        case .cityCollege:
            return self.urlPrefix + "city/college"
        case .jobWarns:
            return self.urlPrefix + "jobs/warns"
        
        }
    }
    
    public  var method: Moya.Method {
        switch self {
        case .guideData, .adviseImages, .helloMsg, .citys, .bussinessField, .subBusinessField,
             .companyType, .internCondition, .cityCollege, .jobWarns:
            return .get
        case .userlogin, .news, .nearByMeetings, .nearyByCompany:
            return .post
        case .setHelloMsg:
            return .put
        case .logout:
            return .delete
        }
    }
        
    
    public var sampleData: Data {
        return "".utf8Encoded
    }
    
    public var task: Task {
        switch self {
        case .guideData, .helloMsg, .adviseImages, .logout, .citys, .bussinessField, .subBusinessField, .companyType, .internCondition, .cityCollege, .jobWarns:
            return Task.requestPlain
        case let .userlogin(phone, password):
            return .requestParameters(parameters: ["phone": phone, "password":password], encoding: JSONEncoding.default)
        case let .setHelloMsg(index):
            return Task.requestParameters(parameters: ["count":index], encoding: URLEncoding.default)
        case let .news(type, offset):
            return Task.requestParameters(parameters: ["type": type, "offset": offset], encoding: JSONEncoding.default)
        case let .nearByMeetings(latitude, longitude, distance):
            return Task.requestParameters(parameters: ["latitude": latitude, "longitude": longitude, "distance": distance, "type": "meetings"], encoding: JSONEncoding.default)
        case let .nearyByCompany(latitude, longitude, distance):
            return Task.requestParameters(parameters: ["latitude": latitude, "longitude": longitude, "distance": distance, "type": "company"], encoding: JSONEncoding.default)
            
        }
    }
    
    public var headers: [String : String]? {
        switch  self {
        case .logout:
            return ["Authorization": GlobalUserInfo.shared.getToken()]
        default:
            return nil
        }
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
            
        case .guideData, .adviseImages, .citys, .bussinessField, .jobWarns:
            timeout = 10
        case .helloMsg, .userlogin, .logout, .news:
            timeout = 30
        case .setHelloMsg(let index):
            timeout = 30
        default:
            timeout = 15
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





















