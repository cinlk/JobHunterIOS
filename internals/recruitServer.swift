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
    case getJobById(id:String, type: jobType)
    case getCompanyJobs(companyId:String, offset:Int)
    //case getCompanyJobsOnlineAppy(companyId:String, offset:Int)
    case getCompanyTagData(req:CompanyTagFilterModel)
    case getCompanyRecruitMeetings(req: CompanyRecruitMeetingFilterModel)
    case getRecruitMeetings(req:CareerTalkFilterModel)
    case getRecruitMeetingById(id:String)
    case getCompany(req:CompanyFilterModel)
    case getCompanyById(id:String)
    case getRecruiterById(id:String)
    
    case onlineApplyJob(onlineApplyId:String, positionId:String)
    case applyJob(jobId:String, type:String)
    
    case collectOnlineApply(onlineApplyId:String, flag:Bool)
    case collectMeeting(careerTalkId:String, flag:Bool)
    case collectCompany(companyId:String, flag:Bool)
    case collectJob(jobId:String, flag:Bool, type: String)
    
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
            return self.prefix + "online/\(id)"
        case .getInternJobs(_):
            return self.prefix + "intern"
        case .getGraduateJobs(_):
            return self.prefix + "graduate"
        case .getJobById(let id, let t):
            
            if t == .graduate{
            return self.prefix + "graduate/\(id)"
            }else if t == .intern{
                return self.prefix + "intern/\(id)"
            }
            return "null"
            
        case .getRecruitMeetings(_):
            return self.prefix +  "carreerTalk"
        case .getRecruitMeetingById(let id):
            return self.prefix +  "meeting/\(id)"
        case .getCompanyRecruitMeetings(_):
            return self.prefix + "company/recruit/meeting"
        case .getCompany(_):
            return self.prefix +  "company"
        case .getCompanyJobs(let companyId, let offset):
            return "company/jobs\(companyId)/\(offset)"
        case .getCompanyById(let id):
            return self.prefix + "company/\(id)"
        case .getCompanyTagData(_):
            return self.prefix + "tag/jobs"
        case .getRecruiterById(let id):
            return self.prefix + "recruiter/\(id)"
        case .onlineApplyJob(let onlineApplyId,let positionId):
            return self.prefix + "online/\(onlineApplyId)/\(positionId)"
        case .applyJob(let jobId, let type):
            return self.prefix + "job/\(type)/\(jobId)"
        case .collectOnlineApply:
            return self.prefix + "online/collect"
        case .collectMeeting:
            return self.prefix + "meeting/collect"
        case .collectCompany:
            return self.prefix + "company/collect"
        case .collectJob:
            return self.prefix + "job/collect"
        
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
        case .getJobById(_,_):
            return Method.get
        case .getCompany(_):
            return Method.post
        case .getCompanyById(_):
            return Method.get
        case .getCompanyJobs(_, _):
            return Method.get
        case .getCompanyRecruitMeetings(_):
            return Method.post
            
        case .getCompanyTagData(_):
            return Method.post
        case .getRecruiterById:
            return Method.get
        case .onlineApplyJob, .applyJob:
            return .put
        case .collectJob, .collectOnlineApply, .collectCompany, .collectMeeting:
            return .post
            
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
        case .getRecruiterById:
            return "".utf8Encoded
        case .getCompanyRecruitMeetings(_):
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
        case .getCompanyRecruitMeetings(let req):
            //return .requestPlain
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
            
        case .getCompanyTagData(var req):
            if req.tag == "全部"{
                req.tag = ""
            }
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
            //return .requestData((data.toJSONString()?.data(using: String.Encoding.utf8))!)
        case .getRecruiterById:
            return .requestPlain
        case .collectJob(let jobId,  let flag, let type):
            return .requestParameters(parameters: ["job_id": jobId, "type": type,"flag":flag], encoding: JSONEncoding.default)
        case .collectOnlineApply(let onlineApplyId, let flag):
            return .requestParameters(parameters: ["online_apply_id": onlineApplyId, "flag": flag], encoding: JSONEncoding.default)
        case .collectCompany(let companyId, let flag):
            return .requestParameters(parameters: ["company_id": companyId, "flag": flag], encoding: JSONEncoding.default)
        case .collectMeeting(let careerTalkId , let flag):
            return .requestParameters(parameters: ["career_talk_id": careerTalkId,"flag":flag], encoding: JSONEncoding.default)
        
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Authorization":  GlobalUserInfo.shared.getToken()]
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
    
    
    internal func getOnlineApplyId(id: String) -> Observable<ResponseModel<OnlineApplyModel>>{
        return httpServer.rx.request(.getOnlineApplyById(id:id)).retry(3).timeout(30, scheduler:ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().mapObject(ResponseModel<OnlineApplyModel>.self)
        
    }
    
    internal  func getInternJobs(req: InternFilterModel) ->Observable<[JobListModel]>{
        
        return httpServer.rx.request(.getInternJobs(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(JobListModel.self, tag: "body")
        
    }
    
    
    internal func getGraduateJobs(req:GraduateFilterModel) ->Observable<[JobListModel]>{
        
        return httpServer.rx.request(.getGraduateJobs(req:req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(JobListModel.self, tag: "body")
    }
    
    
    internal func getJobById(id:String, type: jobType) -> Observable<ResponseModel<CompuseRecruiteJobs>>{
        return httpServer.rx.request(.getJobById(id:id, type: type)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().mapObject(ResponseModel<CompuseRecruiteJobs>.self)
    }
    
    internal func getRecruiteMeetings(req:CareerTalkFilterModel) -> Observable<[CareerTalkMeetingListModel]>{
        return httpServer.rx.request(.getRecruitMeetings(req:req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(CareerTalkMeetingListModel.self, tag: "body")
    }
    
    internal func getRecruitMeetingById(id:String) -> Observable<ResponseModel<CareerTalkMeetingModel>>{
        return httpServer.rx.request(.getRecruitMeetingById(id:id)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<CareerTalkMeetingModel>.self)
        
    }
    
    internal func getCompany(req: CompanyFilterModel) -> Observable<[CompanyListModel]>{
        return httpServer.rx.request(.getCompany(req:req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(CompanyListModel.self, tag: "body")
    }
    
    internal func getCompanyById(id:String) -> Observable<ResponseModel<CompanyModel>>{
        return httpServer.rx.request(.getCompanyById(id:id)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<CompanyModel>.self)
        
    }
    
    

    
    
    internal func getCompanyTagsData(req:CompanyTagFilterModel) -> Observable<[CompanyTagJobs]>{
        
        return httpServer.rx.request(.getCompanyTagData(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(CompanyTagJobs.self, tag: "body")
    }
    
    internal func getCompanyRecruitMeetings(req: CompanyRecruitMeetingFilterModel) -> Observable<[CareerTalkMeetingListModel]>{
        return httpServer.rx.request(.getCompanyRecruitMeetings(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapArray(CareerTalkMeetingListModel.self, tag: "body")
    }
    
    internal func getRecruiterById(id:String) -> Observable<ResponseModel<RecruiterMainModel>>{
        return httpServer.rx.request(.getRecruiterById(id: id)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<RecruiterMainModel>.self)
    }
    
    internal func applyOnlineJob(onlineApplyId:String, positionId:String) -> Observable<ResponseModel<OnlineJobApplyResModel>> {
        
        return httpServer.rx.request(.onlineApplyJob(onlineApplyId: onlineApplyId, positionId: positionId)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<OnlineJobApplyResModel>.self)
    }
    
    internal func applyJob(jobId:String, type:String) -> Observable<ResponseModel<HttpResultMode>>{
        
        return httpServer.rx.request(.applyJob(jobId: jobId, type: type)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    
    // 收藏
    internal func collectOnlineApply(onlineApplyId:String, flag:Bool) -> Observable<ResponseModel<HttpResultMode>> {
        
        return httpServer.rx.request(.collectOnlineApply(onlineApplyId: onlineApplyId, flag: flag)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func collectCareerTalk(careerTalkId:String, flag:Bool) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.collectMeeting(careerTalkId: careerTalkId, flag: flag)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func collectCompany(companyId:String, flag:Bool) ->
        Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.collectCompany(companyId: companyId, flag: flag)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func collectJob(jobId:String, type:String, flag:Bool) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.collectJob(jobId: jobId, flag: flag, type: type)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
}




