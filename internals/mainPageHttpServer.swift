//
//  mainPageHttpServer.swift
//  internals
//
//  Created by ke.liang on 2017/11/25.
//  Copyright © 2017年 lk. All rights reserved.
//



import Foundation
import Moya
import RxSwift
import RxCocoa
import SwiftDate



enum MainPageTarget {
    case getScrollerImage
    case getMainRecommands
    case getRecommandJobs(offset:Int)
    case none
}


extension MainPageTarget:TargetType{
    
    var baseURL: URL {
        return URL.init(string: "https://127.0.0.1:9090/app/api/")!
    }
    
    var path: String {
        switch  self {
        case .getScrollerImage:
            return "topic/category"
        case .getMainRecommands:
            return "job/mainRecommands"
        case .getRecommandJobs(let offset):
            return "job/recommands/\(offset)"
            
        default:
            return "topic"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getScrollerImage:
            return Method.get
        case .getMainRecommands:
            return Method.get
        case .getRecommandJobs(_):
            return Method.get
        default:
            return Method.get
        }
    }
    
    
    var sampleData: Data {
        switch self {
        case .getScrollerImage:
            return "{\"image_url\":\"url\", \"link\":\"test link\"}".utf8Encoded
        case .getMainRecommands:
            return "nothing".utf8Encoded
        case .getRecommandJobs(_):
            return "nothing".utf8Encoded
        default:
            return "".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .getScrollerImage:
            return .requestPlain
        case .getMainRecommands:
            return .requestPlain
        case .getRecommandJobs(_):
            return .requestPlain
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        
        return ["Content-type": "application/json","User-Agent":"ios"]
    }
    
    
}



class  demoHttpServer {
    
    
    static let shared:demoHttpServer = demoHttpServer()
    private lazy var  httpServer: MoyaProvider<MainPageTarget> = {
        let s = MoyaProvider<MainPageTarget>(manager: MoyaManager, plugins: [NetworkLoggerPlugin(verbose: true)])
        return s
    }()
    
    private init(){}

    func getLastestCategory() -> Observable<[RotateCategory]>{
        
        return httpServer.rx.request(.getScrollerImage).filterSuccessfulStatusCodes().asObservable().mapArray(RotateCategory.self, tag: "categories")
    }
    
    func getMainRecommands() -> Observable<SpecialRecommands>{
        
        return httpServer.rx.request(.getMainRecommands).filterSuccessfulStatusAndRedirectCodes().asObservable().mapObject(SpecialRecommands.self).debug()
    }

    // flatMapLatest 连续请求时只取第一次数据
    //
    func getRecommandJobs(offset:Int) -> Observable<[CompuseRecruiteJobs]>{
        return httpServer.rx.request(.getRecommandJobs(offset:offset)).retry(3).timeout(30, scheduler: MainScheduler.instance).filterSuccessfulStatusCodes().asObservable().debug().mapArray(CompuseRecruiteJobs.self, tag: "jobs").flatMapLatest({ (jobs)  in
            return Observable<[CompuseRecruiteJobs]>.just(jobs)
        }).share()
        
    }

}


// job 参数
enum Jobs{
    
    case getInternshipJobs(limit:Int)
    case getCompuseJobs(limit:Int)
    case getImageBanners
    case getCatagoryItem
    case getRecommandItems
    case searchJobs(word:String)
    case getAlls
    
}



extension Jobs: TargetType{
    
    var baseURL: URL {
        return URL.init(string: GlobalConfig.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case  let .getInternshipJobs(limit):
            return "/intershipJobs/\(limit)"
        // test
        case let .getCompuseJobs(limit):
            return "/compuseJobs/\(limit)"
        case .getCatagoryItem:
            return "/catagories"
        case .getRecommandItems:
            return "/recommands"
        case .getImageBanners:
            return "/banners"
        case let .searchJobs(word):
            return "/jobs/\(word)"  // MARK  restfull post?
        default:
            return "/index"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getInternshipJobs:
            return .get
        case .getCompuseJobs:
            return .get
        case .getRecommandItems:
            return .get
        case .getCatagoryItem:
            return .get
        case .getImageBanners:
            return .get
        case .searchJobs:
            return .get
        default:
            return .head
        }
    }
    
    var sampleData: Data {
        // MARK
        let data:[String: Any] = ["InternshipJobs":
        [
        "picture":"image1",
        "comapany":"",
        "jobName":"",
        "address":"",
        "salary":"",
        "create_time":"",
        "day":5,
        "duration":"",
        "isOfficial":false,
        "education":""
        ]
        
        ]
        return  try! JSONSerialization.data(withJSONObject: data, options: [])
        
    }
    
    var parameterEncoding: ParameterEncoding{
        
        return URLEncoding.default
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var validate: Bool{
        return false
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}


class mainPageServer {
    
    
    var httpRequest = MoyaProvider<Jobs>.init()
    static let shareInstance:mainPageServer = mainPageServer.init()
    
    
    private init(){}
    


    
    // MARK 搜索校招和实习职位
    public func searchJobsByWord(word:String) -> Observable<[CompuseRecruiteJobs]> {
        return self.httpRequest.rx.request(Jobs.searchJobs(word: word)).filterSuccessfulStatusCodes().asObservable().mapArray(CompuseRecruiteJobs.self, tag: "CompuseRecruiteJobs")
        
    }
    // test
    public func searchCareerTalk(word:String) -> Observable<[CareerTalkMeetingModel]>{
        var res:[CareerTalkMeetingModel] = []
        for _ in 0..<12{
            
            guard let data = CareerTalkMeetingModel(JSON: ["id":"dqw-dqwd","companyModel":["id":"com-dqwd-5dq","name":"公司名字","describe":"达瓦大群-dqwd","isValidate":true,"isCollected":false,"address":["地址1","地址2"],"icon":"volk","industry":["教育","医疗","化工"]],
                                                           "college":"北京大学","address":"教学室二"
                ,"isValidate":true,"isCollected":false,"icon":"car","start_time":Date().timeIntervalSince1970,
                 "name":"北京高华证券有限责任公司宣讲会但钱当前无多群","source":"上海交大",
                 "content":"举办方：电院举办时间：2018年4月25日 18:00~20:00  \n举办地点：上海交通大学 - 上海市东川路800号电院楼群3-100会议室 单位名称：北京高华证券有限责任公司 联系方式：专业要求：不限、信息安全类、自动化类、计算机类、电子类、软件工程类"]) else {
                continue
            }
            
             res.append(data)
        }
        
        return Observable.just(res)
        
    }
    
    public func searchCompany(word:String) -> Observable<[CompanyModel]>{
        var res:[CompanyModel] = []
        for _ in 0..<12{
            res.append(CompanyModel(JSON: ["id":"dqw-dqwd","name":"公司名",
                                           "describe":"大哇多无多首先想到的肯定是结束减速的代理方法：scrollViewDscrollViewDidEndDecelerating代理方法的，如果做过用3个界面+scrollView实现循环滚动展示图片，那么基本上都会碰到这么问题。如何准确的监听翻页？我的解决的思路如下达瓦大文大无大无多无大无大无多哇大无多无飞啊飞分为飞飞飞达瓦大文大无大无多哇付达瓦大文大无付多无dwadwadadawdawde吊袜带挖多哇建外大街文档就frog忙不忙你有他们今天又摸排个人票买房可免费课时费\n个人个人，二哥，二\n吊袜带挖多，另外的码问了；吗\n","address":["地址1","地址2"],"icon":"volk","industry":["教育","医疗","化工"],"webSite":"https://www.baidu.com","tags":["标签1","标签1测试","标签89我的当前","当前为多","迭代器","群无多当前为多群当前","达瓦大群无多", "当前为多当前的群","当前为多无", "当前为多群无多","杜德伟七多"],"follows":arc4random()%1000,"isValidate":true,"isCollected":false])!)
        }
        return Observable.just(res)
        
    }
    
    public func searchOnlineApply(word:String) -> Observable<[OnlineApplyModel]>{
        var res:[OnlineApplyModel] = []
        for _ in 0..<5{
            
            if let data = OnlineApplyModel(JSON: ["id":"fq-4320-dqwd","end_time":Date().timeIntervalSince1970,"create_time":Date().timeIntervalSince1970,"positionAddress":["成都","重庆"],"content":"dqwdqwdqwddqwdqwdqwddqwdqwdqwddqwdqwdqwdqwdqwdwqdqwdqwdqw","outer":true,
                                                  "majors":["土木工程","软件工程","其他"],"positions":["设计","测试","销售"],"link":"http://campus.51job.com/padx2018/index.html","isApply":false,"isValidate":true,"isCollected":true,"name":"当前为多群无多群无多","companyModel":["id":"dqwdqw","name":"company1","address":["地址1","地址2"],"icon":"volk","industry":["教育","医疗","化工"],"isValidate":true,"isCollected":false]]){
                 res.append(data)
                
            }
        }
            
            for _ in 0..<5{
                if let data = OnlineApplyModel(JSON: ["id":"fq-4320-dqwd","end_time":Date().timeIntervalSince1970,"create_time":Date().timeIntervalSince1970,"positionAddress":["成都","重庆"],"content":"dqwdqwdqwddqwdqwdqwddqwdqwdqwddqwdqwdqwdqwdqwdwqdqwdqwdqw","outer":false,
                                                      "majors":["土木工程","软件工程","其他"],"positions":["设计","测试","销售"],"link":"http://campus.51job.com/padx2018/index.html","isApply":false,"isValidate":true,"isCollected":true,"name":"当前为多群无多","companyModel":["id":"dqwdqw","name":"company1","address":["地址1","地址2"],"icon":"volk","industry":["教育","医疗","化工"],"isValidate":true,"isCollected":false]]){
                    res.append(data)
            }
        }
                
           
        
        return Observable.just(res)
    }
    
}
