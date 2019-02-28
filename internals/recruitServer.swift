//
//  recruiteServer.swift
//  internals
//
//  Created by ke.liang on 2018/9/14.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import ObjectMapper





enum RecruitTarget{
    
    //case getOnlineApply(mode:RecruitOnlineApply, offset:Int)
    case getOnlineApply(req:OnlineFilterReqModel)
    case getOnlineApplyById(id:String)
    case getInternJobs(req:InternFilterModel)
    case getGraduateJobs(req:GraduateFilterModel)
    case getJobById(id:String)
    case getCompanyJobs(companyId:String, offset:Int)
    //case getCompanyJobsOnlineAppy(companyId:String, offset:Int)
    case getCompanyTagData(data:TagsDataItem)
    case getCompanyRecruitMeetings(companyId:String, offset:Int)
    case getRecruitMeetings(req:CareerTalkFilterModel)
    case getRecruitMeetingById(id:String)
    case getCompany(req:CompanyFilterModel)
    case getCompanyById(id:String)
    case getWarnJobMessage
    
    case none
}


extension RecruitTarget: TargetType{
    
    
    var baseURL: URL {
        return URL.init(string: GlobalConfig.BASE_URL)!
    }
    
    var prefix:String{
        return "recruite/"
    }
    
    var path: String {
        switch  self {
        case .getOnlineApply(_):
            return self.prefix +  "online"
        case .getOnlineApplyById(let id):
            return "onlineApply/item/\(id)"
        case .getInternJobs(_):
            return self.prefix + "intern"
        case .getGraduateJobs(_):
            return self.prefix + "graduate"
        case .getJobById(let id):
            return "job/item/\(id)"
        case .getRecruitMeetings(_):
            return self.prefix +  "carreerTalk"
        case .getRecruitMeetingById(let id):
            return "recruitMeeting/item/\(id)"
        case .getCompanyRecruitMeetings(let companyId, let offset):
            return "company/recruitMeeting/\(companyId)/\(offset)"
        case .getCompany(_):
            return self.prefix +  "company"
        case .getCompanyJobs(let companyId, let offset):
            return "company/jobs\(companyId)/\(offset)"
        case .getCompanyById(let id):
            return "company/item/\(id)"
//        case .getCompanyJobsOnlineAppy(let companyId, let offset):
//            return "company/combination/\(companyId)/\(offset)"
        case .getCompanyTagData(_):
            return "company/tags/data"
        case .getWarnJobMessage:
            return "job/warn/message"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        
        switch  self {
        case .getOnlineApply(_):
            return Method.post
        case .getOnlineApplyById(_):
            return Method.get
        case .getInternJobs(_):
            return Method.post
        case .getGraduateJobs(_):
            return Method.post
        case .getRecruitMeetings(_):
            return Method.post
        case .getRecruitMeetingById(_):
            return Method.get
        case .getJobById(_):
            return Method.get
        case .getCompany(_):
            return Method.post
        case .getCompanyById(_):
            return Method.get
        case .getCompanyJobs(_, _):
            return Method.get
        case .getCompanyRecruitMeetings(_, _):
            return Method.get
            
        case .getCompanyTagData(_):
            return Method.get
        case .getWarnJobMessage:
            return Method.get
        default:
            return Method.get
        }
    }
    
    var sampleData: Data {
        switch  self {
        case .getOnlineApply(_):
            return "".utf8Encoded
        case .getOnlineApplyById(_):
            return "".utf8Encoded
            
        case .getInternJobs(_):
            return "".utf8Encoded
        case .getGraduateJobs(_):
            return "".utf8Encoded
        case .getRecruitMeetings(_):
            return "".utf8Encoded
        case .getRecruitMeetingById(_):
            return "".utf8Encoded
        case .getJobById(_):
            return "".utf8Encoded
            
        case .getCompany(_):
            return "".utf8Encoded
        case .getCompanyById(_):
            return "".utf8Encoded
        case .getCompanyJobs(_, _):
            return "".utf8Encoded
        case .getWarnJobMessage:
            return "".utf8Encoded
        case .getCompanyRecruitMeetings(_, _):
            return "".utf8Encoded
        case .getCompanyTagData(_):
            return "".utf8Encoded
        default:
            return "".utf8Encoded
        }
    }
    
    var task: Task {
        switch  self {
        case .getOnlineApply(let req):
            
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .getOnlineApplyById(_):
            return .requestPlain
        case .getInternJobs(let req):
            //return .requestPlain
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .getGraduateJobs(let req):
            //return .requestPlain
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .getJobById(_):
            return .requestPlain
        case .getRecruitMeetings(let req):
            //return .requestPlain
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .getRecruitMeetingById(_):
            return .requestPlain
        case .getCompany(let req):
            //return .requestPlain
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .getCompanyJobs(_, _):
            return .requestPlain
        case .getCompanyById(_):
            return .requestPlain
        case .getCompanyRecruitMeetings(_, _):
            return .requestPlain
        case .getCompanyTagData(let data):
            return .requestData((data.toJSONString()?.data(using: String.Encoding.utf8))!)
        case .getWarnJobMessage:
            return .requestPlain
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}


class RecruitServer{
    
    
    
    static let shared:RecruitServer = RecruitServer()
    
    private lazy var httpServer:MoyaProvider<RecruitTarget> = {
        let s = MoyaProvider<RecruitTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])
        return s
    }()
    
    
    private init() {}
    
    
    internal func getOnlineApply(req:OnlineFilterReqModel) -> Observable<[OnlineApplyListModel]>{
        
        return httpServer.rx.request(.getOnlineApply(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(OnlineApplyListModel.self, tag: "body")
    }
    
    
    internal func getOnlineApplyId(id: String) -> Observable<OnlineApplyModel>{
        return httpServer.rx.request(.getOnlineApplyById(id:id)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).filterSuccessfulStatusCodes().asObservable().observeOn(MainScheduler.instance).mapObject(OnlineApplyModel.self)
        
    }
    
    internal  func getInternJobs(req: InternFilterModel) ->Observable<[JobListModel]>{
        
        return httpServer.rx.request(.getInternJobs(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(JobListModel.self, tag: "body")
        
    }
    
    
    internal func getGraduateJobs(req:GraduateFilterModel) ->Observable<[JobListModel]>{
        
        return httpServer.rx.request(.getGraduateJobs(req:req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(JobListModel.self, tag: "body")
    }
    
    
    internal func getJobById(id:String) -> Observable<CompuseRecruiteJobs>{
        return httpServer.rx.request(.getJobById(id:id)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).filterSuccessfulStatusCodes().asObservable().observeOn(MainScheduler.instance).mapObject(CompuseRecruiteJobs.self)
    }
    
    internal func getRecruiteMeetings(req:CareerTalkFilterModel) -> Observable<[CareerTalkMeetingListModel]>{
        return httpServer.rx.request(.getRecruitMeetings(req:req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(CareerTalkMeetingListModel.self, tag: "body")
    }
    
    internal func getRecruitMeetingById(id:String) -> Observable<CareerTalkMeetingModel>{
        return httpServer.rx.request(.getRecruitMeetingById(id:id)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).filterSuccessfulStatusCodes().asObservable().observeOn(MainScheduler.instance).mapObject(CareerTalkMeetingModel.self)
        
    }
    
    internal func getCompany(req: CompanyFilterModel) -> Observable<[CompanyListModel]>{
        return httpServer.rx.request(.getCompany(req:req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(CompanyListModel.self, tag: "body")
    }
    
    internal func getCompanyById(id:String) -> Observable<CompanyModel>{
        return httpServer.rx.request(.getCompanyById(id:id)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).filterSuccessfulStatusCodes().asObservable().observeOn(MainScheduler.instance).mapObject(CompanyModel.self)
        
    }
    
    internal func getJobWarnMessage() -> Observable<[String]>{
        return httpServer.rx.request(.getWarnJobMessage).retry(3).timeout(30, scheduler: MainScheduler.instance).debug().filterSuccessfulStatusCodes().mapJSON().asObservable().flatMapLatest { (any) -> Observable<[String]> in
            if let json = any as? [String:[String]], let item = json["warn_message"]{
                return Observable<[String]>.just(item)
            }else{
                return Observable<[String]>.just([])
            }
            
        }.share()
    }
    
    
    internal func getCompanylistJobs(companyId:String, offset:Int) -> Observable<[CompuseRecruiteJobs]>{
        return httpServer.rx.request(.getCompanyJobs(companyId:companyId, offset: offset)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).filterSuccessfulStatusCodes().asObservable().observeOn(MainScheduler.instance).mapArray(CompuseRecruiteJobs.self, tag: "list_jobs")
    }
    
    
    internal func getCompanyTagsData(data:TagsDataItem) -> Observable<ListJobsOnlineAppy>{
        
        return httpServer.rx.request(.getCompanyTagData(data: data)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).filterSuccessfulStatusCodes().asObservable().observeOn(MainScheduler.instance).mapObject(ListJobsOnlineAppy.self)
    }
    
    internal func getCompanyRecruitMeetings(companyId:String, offset:Int) -> Observable<[CareerTalkMeetingListModel]>{
        return httpServer.rx.request(.getCompanyRecruitMeetings(companyId: companyId, offset: offset)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).filterSuccessfulStatusCodes().asObservable().observeOn(MainScheduler.instance).mapArray(CareerTalkMeetingListModel.self, tag: "meetings")
    }
}




