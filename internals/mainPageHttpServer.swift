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
        return URL.init(string: APP_JOB_URL)!
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
    
    
    // MARK
    public func getCompuseJobs(index:Int) -> Observable<[CompuseRecruiteJobs]> {
        
        return self.httpRequest.rx.request(Jobs.getCompuseJobs(limit: index)).asObservable().mapArray(CompuseRecruiteJobs.self,tag:"CompuseRecruiteJobs")
    }
    // MARK
    public func getCatagories() -> Observable<[String:String]> {
        return Observable.just(["hotJobs":"热门职位","fastOffer":"急招职位","accountIn":"户口机会","highPlay":"高薪职位","flyPig":"行业风口"])
        
    }
    // MARK
    public func getRecommand() -> Observable<[String:String]> {
        return Observable.just(["ali":"https://job.alibaba.com/zhaopin/index.htm","xiaomiDefault":"http://hr.xiaomi.com/","service1":"http://www.sohu.com/a/151070865_219733","company2":"https://tour.go-zh.org/welcome/1"])
    }
    //MARK
    public func getImageBanners() -> Observable<[RotateImages]>{
        
        return self.httpRequest.rx.request(Jobs.getImageBanners).asObservable().mapArray(RotateImages.self, tag: "RotateImages")
    }
    
    public func getHotRecruitMeetings()->Observable<[simpleRecruitModel]>{
        //return self.httpRequest.rx.request(<#T##token: Jobs##Jobs#>)
        var res:[simpleRecruitModel] = []
        for _ in 0..<12{
            res.append(simpleRecruitModel(JSON: ["image":"sina","title":"公司名字","des":"那个大学",
                                                 "time":Date.init().timeIntervalSince1970])!)
        }
        
        return Observable.just(res)
        
    }
    
    //
    public func getHotApplyOnlines()->Observable<[applyOnlineModel]>{
        return Observable.just([applyOnlineModel(JSON: ["imageIcon":"ali","type":"","title":"独角兽"])!,
                                applyOnlineModel(JSON: ["imageIcon":"ali","type":"","title":"独角兽"])!,
                                applyOnlineModel(JSON: ["imageIcon":"ali","type":"","title":"独角兽"])!,
                                applyOnlineModel(JSON: ["imageIcon":"ali","type":"","title":"独角兽"])!,
                                applyOnlineModel(JSON: ["imageIcon":"ali","type":"","title":"独角兽"])!,
                                applyOnlineModel(JSON: ["imageIcon":"ali","type":"","title":"独角兽"])!])
    }
    // MARK search jobs
    public func searchKeyByWord(word:String) -> Observable<[CompuseRecruiteJobs]> {
        return self.httpRequest.rx.request(Jobs.searchJobs(word: word)).filterSuccessfulStatusCodes().asObservable().mapArray(CompuseRecruiteJobs.self, tag: "CompuseRecruiteJobs")
        
    }
    
    
}
