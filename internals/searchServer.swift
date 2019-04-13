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
    case searchOnlineAppy(word:String)
    case searchGraduateJobs(word:String)
    case searchInternJobs(word:String)
    case searchCareerTalkMeetins(word: String)
    case searchCompany(word:String)
    case none
}


extension SearchTarget: TargetType{
    
    var baseURL: URL {
        
        return URL.init(string: GlobalConfig.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getHotestRecords(let type):
            return "search/word/\(type)"
        case .searchKeyWords(_,_):
            return "search/similar"
        case .searchOnlineAppy(_):
            return "search/online"
        case .searchGraduateJobs(_):
            return "search/graduate"
        case .searchInternJobs(_):
            return "search/intern"
        case .searchCareerTalkMeetins(_):
            return "search/careerTalk"
        case .searchCompany(_):
            return "search/company"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getHotestRecords(_):
            return Method.get
        case .searchKeyWords(_, _):
            return Method.post
        case .searchOnlineAppy(_):
            return Method.post
        case .searchGraduateJobs(_):
            return Method.post
        case .searchInternJobs(_):
            return Method.post
        case .searchCareerTalkMeetins(_):
            return Method.post
        case .searchCompany(_):
            return Method.post
        default:
            return Method.get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getHotestRecords(_):
            return "[\"dqwd\",\"当前为多\",\"dwqdwq\",\"等我大大群无\",\"带我去的\",\"dqwdwq\",\"达瓦大群无\",\"fewfewf\"]".utf8Encoded
        case .searchKeyWords(_,_):
            return "[\"type\":\"jobs\",\"matchs\":\"[\"word1\",\"word2\",\"word3\"]\"]".utf8Encoded
        case .searchOnlineAppy(_):
            return "{}".utf8Encoded
        case .searchGraduateJobs(_):
            return "{}".utf8Encoded
        case .searchInternJobs(_):
            return "{}".utf8Encoded
        case .searchCareerTalkMeetins(_):
            return "{}".utf8Encoded
        case .searchCompany(_):
            return "{}".utf8Encoded
        default:
            return "".utf8Encoded
        }
    }
    
    
    var task: Task {
        switch self {
        case .getHotestRecords(_):
            return .requestPlain
        case let .searchKeyWords(word, type):
            return .requestParameters(parameters: ["type":type, "word":word], encoding: JSONEncoding.default)
            //return .requestPlain
        case .searchOnlineAppy(let word):
//            return .requestData((mode.toJSONString()?.data(using: String.Encoding.utf8))!)
            return .requestParameters(parameters: ["word": word], encoding: JSONEncoding.default)
        case .searchGraduateJobs(let word):
            //return .requestData((mode.toJSONString()?.data(using: .utf8))!)
            return .requestParameters(parameters: ["word":word], encoding: JSONEncoding.default)
        case .searchInternJobs(let word):
            //return .requestData((mode.toJSONString()?.data(using: .utf8))!)
            return .requestParameters(parameters: ["word": word], encoding: JSONEncoding.default)
        case .searchCareerTalkMeetins(let word):
            //return .requestData((mode.toJSONString()?.data(using: .utf8))!)
            return .requestParameters(parameters: ["word": word], encoding: JSONEncoding.default)
        case .searchCompany(let word):
            //return .requestData((mode.toJSONString()?.data(using: .utf8))!)
            return .requestParameters(parameters: ["word": word], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        
        return  nil

    }
    
    
    
}



class SearchServer{
    
    static let shared:SearchServer = SearchServer()
    private lazy var httpServer:MoyaProvider<SearchTarget> = {
        let s = MoyaProvider<SearchTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])
        return s
    }()
    
    private init(){}
    
    
    
    func getTopWords(type:String) -> Observable<ResponseArrayModel<TopWord>>{
        return httpServer.rx.request(.getHotestRecords(type: type)).timeout(30, scheduler: MainScheduler.instance).asObservable().mapObject(ResponseArrayModel<TopWord>.self)
        
        
    
    }
    
    
    func getMatchedWords(type:String, word:String) -> Observable<ResponseModel<MatchKeyWordsModel>>{
       
        
        return httpServer.rx.request(.searchKeyWords(word:word, type: type)).retry(3).timeout(30, scheduler: MainScheduler.instance).asObservable().mapObject(ResponseModel<MatchKeyWordsModel>.self)
    }
    
    
    func searchOnlineAppy(word:String) -> Observable<[OnlineApplyListModel]>{
        
        return httpServer.rx.request(.searchOnlineAppy(word: word)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(OnlineApplyListModel.self, tag: "body")
    }
    
    
    func searchGraduateJobs(word:String) ->Observable<[JobListModel]>{
        
        return  httpServer.rx.request(.searchGraduateJobs(word:word)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(JobListModel.self, tag: "body")
        
    }
    
    
    func searchInternJobs(word:String) -> Observable<[JobListModel]>{
        
        return httpServer.rx.request(.searchInternJobs(word:word)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(JobListModel.self, tag: "body")
        
    }
    
    
    func searchCareerTalkMeetins(word: String) -> Observable<[CareerTalkMeetingListModel]>{
        
        return httpServer.rx.request(.searchCareerTalkMeetins(word: word)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(CareerTalkMeetingListModel.self, tag: "body")
    }
    
    
    func searchCompany(word: String) -> Observable<[CompanyListModel]>{
        return httpServer.rx.request(.searchCompany(word:word)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(CompanyListModel.self, tag: "body")
        
    }
}





