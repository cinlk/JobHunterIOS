//
//  searchServer.swift
//  internals
//
//  Created by ke.liang on 2018/9/10.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import ObjectMapper




enum SearchTarget {
    
    case getHotestRecords(type:String)
    // type 板块内关键词匹配
    case searchKeyWords(word:String, type:String)
    case searchOnlineAppy(mode:searchOnlineApplyBody, offset:Int)
    case searchGraduateJobs(mode:searchGraduateRecruiteBody, offset:Int)
    case searchInternJobs(mode:searchInternJobsBody, offset:Int)
    case searchCareerTalkMeetins(mode: searchCareerTalkBody, offset:Int)
    case searchCompany(mode: searchCompanyBody, offset:Int)
    case none
}


extension SearchTarget: TargetType{
    
    var baseURL: URL {
        return URL.init(string: "https://127.0.0.1:9090/app/api/")!
    }
    
    var path: String {
        switch self {
        case .getHotestRecords(let type):
            return "search/word/\(type)"
        case .searchKeyWords(let word, let type):
            return "search/match/\(type)/\(word)"
        case .searchOnlineAppy(_,let offset):
            return "search/onlineApply/\(offset)"
        case .searchGraduateJobs(_, let offset):
            return "search/graduateJobs/\(offset)"
        case .searchInternJobs(_, let offset):
            return "search/internJobs/\(offset)"
        case .searchCareerTalkMeetins(_, let offset):
            return "search/careerTalkMeeting/\(offset)"
        case .searchCompany(_, let offset):
            return "search/company/\(offset)"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getHotestRecords(_):
            return Method.get
        case .searchKeyWords(_, _):
            return Method.get
        case .searchOnlineAppy(_,_):
            return Method.post
        case .searchGraduateJobs(_, _):
            return Method.post
        case .searchInternJobs(_, _):
            return Method.post
        case .searchCareerTalkMeetins(_, _):
            return Method.post
        case .searchCompany(_, _):
            return Method.post
        default:
            return Method.get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getHotestRecords(_):
            return "[\"dqwd\",\"当前为多\",\"dwqdwq\",\"等我大大群无\",\"带我去的\",\"dqwdwq\",\"达瓦大群无\",\"fewfewf\"]".utf8Encoded
        case .searchKeyWords(_, _):
            return "[\"type\":\"jobs\",\"matchs\":\"[\"word1\",\"word2\",\"word3\"]\"]".utf8Encoded
        case .searchOnlineAppy(_):
            return "{}".utf8Encoded
        case .searchGraduateJobs(_, _):
            return "{}".utf8Encoded
        case .searchInternJobs(_, _):
            return "{}".utf8Encoded
        case .searchCareerTalkMeetins(_, _):
            return "{}".utf8Encoded
        case .searchCompany(_, _):
            return "{}".utf8Encoded
        default:
            return "".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .getHotestRecords(_):
            return .requestPlain
        case .searchKeyWords(_, _):
            return .requestPlain
        case .searchOnlineAppy(let mode,  _):
            return .requestData((mode.toJSONString()?.data(using: String.Encoding.utf8))!)
        case .searchGraduateJobs(let mode, _):
            return .requestData((mode.toJSONString()?.data(using: .utf8))!)
        case .searchInternJobs(let mode, _):
            return .requestData((mode.toJSONString()?.data(using: .utf8))!)
        case .searchCareerTalkMeetins(let mode, _):
            return .requestData((mode.toJSONString()?.data(using: .utf8))!)
        case .searchCompany(let mode, _):
            return .requestData((mode.toJSONString()?.data(using: .utf8))!)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        
        return ["Content-type": "application/json","User-Agent":"ios","Accept":"application/json"]

    }
    
    
    
}



class SearchServer{
    
    static let shared:SearchServer = SearchServer()
    private lazy var httpServer:MoyaProvider<SearchTarget> = {
        let s = MoyaProvider<SearchTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])
        return s
    }()
    
    private init(){}
    
    
    
    func getTopWords(type:String) -> Observable<[String]>{
        return httpServer.rx.request(.getHotestRecords(type: type)).timeout(30, scheduler: MainScheduler.instance).filterSuccessfulStatusCodes().asObservable().mapJSON().map{
            json -> [String] in
            guard let j = json as? [String:[String]] else {
                return []
            }
            guard let words = j["words"] else{
                return []
            }
            return words
            
        }.catchErrorJustReturn([]).share().debug()
        
    
    }
    
    
    func getMatchedWords(type:String, word:String) -> Observable<MatchKeyWordsModel>{
       
        return httpServer.rx.request(.searchKeyWords(word:word, type: type)).retry(3).timeout(3, scheduler: MainScheduler.instance).filterSuccessfulStatusCodes().asObservable().mapObject(MatchKeyWordsModel.self)
    }
    
    
    func searchOnlineAppy(mode:searchOnlineApplyBody, offset:Int) -> Observable<[OnlineApplyModel]>{
        
        return httpServer.rx.request(.searchOnlineAppy(mode: mode, offset: offset)).retry(3).timeout(3, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).filterSuccessfulStatusCodes().asObservable().observeOn(MainScheduler.instance).mapArray(OnlineApplyModel.self, tag: "applies")
    }
    
    
    func searchGraduateJobs(mode:searchGraduateRecruiteBody, offset:Int) ->Observable<[CompuseRecruiteJobs]>{
        
        return  httpServer.rx.request(.searchGraduateJobs(mode:mode, offset:offset)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).filterSuccessfulStatusCodes().asObservable().observeOn(MainScheduler.instance).mapArray(CompuseRecruiteJobs.self, tag: "jobs")
        
    }
    
    
    func searchInternJobs(mode: searchInternJobsBody, offset:Int) -> Observable<[CompuseRecruiteJobs]>{
        
        return httpServer.rx.request(.searchInternJobs(mode:mode, offset:offset)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).filterSuccessfulStatusCodes().asObservable().observeOn(MainScheduler.instance).mapArray(CompuseRecruiteJobs.self, tag: "jobs")
        
    }
    
    
    func searchCareerTalkMeetins(mode: searchCareerTalkBody, offset: Int) -> Observable<[CareerTalkMeetingModel]>{
        
        return httpServer.rx.request(.searchCareerTalkMeetins(mode:mode, offset: offset)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).filterSuccessfulStatusCodes().asObservable().observeOn(MainScheduler.instance).mapArray(CareerTalkMeetingModel.self, tag: "meetings")
    }
    
    
    func searchCompany(mode: searchCompanyBody, offset:Int) -> Observable<[CompanyModel]>{
        return httpServer.rx.request(.searchCompany(mode:mode, offset: offset)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).filterSuccessfulStatusCodes().asObservable().observeOn(MainScheduler.instance).mapArray(CompanyModel.self, tag: "company")
        
    }
}





