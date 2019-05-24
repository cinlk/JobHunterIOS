//
//  PersonServer.swift
//  internals
//
//  Created by ke.liang on 2019/5/18.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya





internal enum personTarget{
    case userAvatar(imageData:Data, imageName:String)
    case userBrief(req: PersonBriefReq)
    case delivery
    case deliveryStatus(jobId:String, type:String)
    case getOnlineApplyId(positionId:String)
    case resumeList
    case changeResumeName(resumeId:String, name:String)
    case newTextResume
    case newAttachResume(fileData:Data, name:String)
    case primaryResume(resumeId:String)
    case deleteResume(resumeId:String, type:String)
    case textResumeInfo(resumeId:String)
    case baseInfoAvatar(resumeId:String, data:Data, name:String)
    case baseInfoContent(req:TextResumeBaseInfoReq)
    case newTextResumeEducation(req:TextResumeEducationReq)
    case updateTextResumeEducation(id:String, req:TextResumeEducationReq)
    case deleteTextResumeEducation(resumeId:String, id:String)
    
    case newTextResumeWork(req:TextResumeWorkReq)
    case updateTextResumeWork(id:String, req:TextResumeWorkReq)
    case deleteTextResumeWork(resumeId:String, id:String)
    
    case newTextResumeProject(req:TextResumeProjectReq)
    case updateTextResumeProject(id:String, req:TextResumeProjectReq)
    case deleteTextResumeProject(resumeId:String, id:String)
    
    case newTextResumeCollegeActive(req:TextResumeCollegeActiveReq)
    case updateTextResumeCollegeActive(id:String, req:TextResumeCollegeActiveReq)
    case deleteTextResumeCollegeActive(resumeId:String, id:String)
    
    
    case newTextResumeSocialPractice(req:TextResumeSocialPracticeReq)
    case updateTextResumeSocialPractice(id:String, req:TextResumeSocialPracticeReq)
    case deleteTextResumeSocialPractice(resumeId:String, id:String)
    
    
    
    case newTextResumeSkill(req:TextResumeSkillReq)
    case updateTextResumeSkill(id:String, req:TextResumeSkillReq)
    case deleteTextResumeSkill(resumeId:String, id:String)
    
    
    case newTextResumeOther(req:TextResumeOtherReq)
    case updateTextResumeOther(id:String, req:TextResumeOtherReq)
    case deleteTextResumeOther(resumeId:String, id:String)
    
    case updateTextResumeEstimate(id:String, req: TextResumeEstimateReq)
    
    case attachResume(resumeId:String)
    
    
    
    
    case none
}


extension personTarget: TargetType{
    
    var baseURL: URL {
        return URL.init(string: GlobalConfig.BASE_URL)!
    }
    
    var prefix:String{
        return "person"
    }
    
    var path: String {
        switch self {
        case .userAvatar:
            return self.prefix + "/avatar"
        case .userBrief:
            return self.prefix + "/brief"
        case .delivery:
            return self.prefix + "/delivery"
        case .deliveryStatus(let jobId, let type):
            return self.prefix + "/delivery/history/\(type)/\(jobId)"
        case .getOnlineApplyId(let positionId):
            return self.prefix + "/onlineApplyId/\(positionId)"
        case .resumeList:
            return self.prefix + "/resumes"
        case .changeResumeName:
            return self.prefix + "/resume/name"
        case .newTextResume:
            return self.prefix + "/textResume"
        case .newAttachResume:
            return self.prefix + "/attacheResume"
        case .primaryResume(let resumeId):
            return self.prefix + "/primary/resume/\(resumeId)"
        case .deleteResume(let resumeId, let type):
            return self.prefix + "/resume/\(type)/\(resumeId)"
        case .textResumeInfo(let resumeId):
            return self.prefix + "/text/resume/\(resumeId)"
        case .baseInfoAvatar(let resumeId, _,_):
            return self.prefix + "/textResume/baseInfo/avatar/\(resumeId)"
        case .baseInfoContent:
            return self.prefix + "/textResume/baseInfo/content"
        case .newTextResumeEducation:
            return self.prefix + "/textResume/education"
        case .updateTextResumeEducation(let id, _):
            return self.prefix + "/textResume/education/\(id)"
        case .deleteTextResumeEducation(let resumeId, let id):
            return self.prefix + "/textResume/education/\(resumeId)/\(id)"
            
            
        case .newTextResumeWork(_):
            return self.prefix + "/textResume/work"
        case .updateTextResumeWork(let id, _):
            return self.prefix + "/textResume/work/\(id)"
        case .deleteTextResumeWork(let resumeId, let id):
            return self.prefix + "/textResume/work/\(resumeId)/\(id)"
            
        case .newTextResumeProject:
            return self.prefix + "/textResume/project"
        case .updateTextResumeProject(let id,_):
            return self.prefix + "/textResume/project/\(id)"
        case .deleteTextResumeProject(let resumeId, let id):
            return self.prefix + "/textResume/project/\(resumeId)/\(id)"
        
            
            
        case .newTextResumeCollegeActive:
            return self.prefix + "/textResume/college"
        case .updateTextResumeCollegeActive(let id,_):
            return self.prefix + "/textResume/college/\(id)"
        case .deleteTextResumeCollegeActive(let resumeId, let id):
            return self.prefix + "/textResume/college/\(resumeId)/\(id)"
            
        
        case .newTextResumeSkill:
            return self.prefix + "/textResume/skill"
        case .updateTextResumeSkill(let id,_):
            return self.prefix + "/textResume/skill/\(id)"
        case .deleteTextResumeSkill(let resumeId, let id):
            return self.prefix + "/textResume/skill/\(resumeId)/\(id)"
            
        
        case .newTextResumeSocialPractice:
            return self.prefix + "/textResume/socialPractice"
        case .updateTextResumeSocialPractice(let id,_):
            return self.prefix + "/textResume/socialPractice/\(id)"
        case .deleteTextResumeSocialPractice(let resumeId, let id):
            return self.prefix + "/textResume/socialPractice/\(resumeId)/\(id)"
            
            
            
        case .newTextResumeOther:
            return self.prefix + "/textResume/other"
        case .updateTextResumeOther(let id,_):
            return self.prefix + "/textResume/other/\(id)"
        case .deleteTextResumeOther(let resumeId, let id):
            return self.prefix + "/textResume/other/\(resumeId)/\(id)"
            
            
        case .updateTextResumeEstimate(let id, _):
            return self.prefix + "/textResume/estimate/\(id)"
            
            
        case .attachResume(let resumeId):
            return self.prefix + "/attachResume/\(resumeId)"
            
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch  self {
        case .userAvatar, .userBrief, .newTextResume, .newAttachResume, .changeResumeName,.baseInfoContent, .newTextResumeEducation, .newTextResumeWork, .newTextResumeProject, .newTextResumeOther, .newTextResumeSocialPractice, .newTextResumeCollegeActive, .newTextResumeSkill:
            return .post
        case .delivery, .deliveryStatus, .getOnlineApplyId, .resumeList, .textResumeInfo, .attachResume:
            return .get
        case .primaryResume, .baseInfoAvatar, .updateTextResumeEducation, .updateTextResumeWork, .updateTextResumeProject, .updateTextResumeSocialPractice, .updateTextResumeOther, .updateTextResumeCollegeActive, .updateTextResumeEstimate, .updateTextResumeSkill:
            return .put
        case .deleteResume, .deleteTextResumeEducation, .deleteTextResumeOther, .deleteTextResumeSocialPractice,.deleteTextResumeSkill, .deleteTextResumeCollegeActive, .deleteTextResumeProject, .deleteTextResumeWork:
            return .delete
        default:
            return .get
        }
    }
    
    var sampleData: Data {
         return "".utf8Encoded
    }
    
    var task: Task {
        switch  self {
        case .userAvatar(let imageData, let imageName):
            
            let formData: [Moya.MultipartFormData] = [Moya.MultipartFormData(provider: .data(imageData), name: "avatar", fileName: imageName, mimeType: "image/jpeg")]
            
            return .uploadMultipart(formData)
            //return .uploadCompositeMultipart([formData], urlParameters: [])
        case .baseInfoAvatar(_, let data, let name):
            let formData: [Moya.MultipartFormData] = [Moya.MultipartFormData(provider: .data(data), name: "attach", fileName: name, mimeType: "text/plain")]
            return .uploadMultipart(formData)
            
        case .userBrief(let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .newAttachResume(let fileData, let name):
            let formData: [Moya.MultipartFormData] = [Moya.MultipartFormData(provider: .data(fileData), name: "attach", fileName: name, mimeType: "text/plain")]
            return .uploadMultipart(formData)
        case .changeResumeName(let resumeId,  let name):
            return .requestParameters(parameters: ["name": name,"resume_id": resumeId], encoding: JSONEncoding.default)
        case .baseInfoContent(let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .newTextResumeEducation(let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .updateTextResumeEducation(_, let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
            
        case .newTextResumeWork(let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .updateTextResumeWork(_, let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        
        
        case .newTextResumeProject(let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .updateTextResumeProject(_, let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
            
            
        case .newTextResumeCollegeActive(let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .updateTextResumeCollegeActive(_, let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
            
        
        case .newTextResumeSkill(let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .updateTextResumeSkill(_, let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
            
            
        case .newTextResumeSocialPractice(let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .updateTextResumeSocialPractice(_, let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
            
            
        case .newTextResumeOther(let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .updateTextResumeOther(_, let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
            
        case .updateTextResumeEstimate(_, let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
            
            
            
            
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return  ["Content-Type": "application/json", "Authorization": GlobalUserInfo.shared.getToken()]
    }
    
    
}






class PersonServer {
    
   
    static let shared: PersonServer = PersonServer.init()
    private lazy var httpServer: MoyaProvider<personTarget> = {
        let s = MoyaProvider<personTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])
        return s
    }()
    
    private init() {}
}


extension PersonServer{
    
    internal func updateAvatar(data:Data, name:String) -> Observable<ResponseModel<HttpAvatarResModel>>{
        
        
        return self.httpServer.rx.request(.userAvatar(imageData: data, imageName: name)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpAvatarResModel>.self)
    }
    
    internal func updatePersonBrief(req: PersonBriefReq) -> Observable<ResponseModel<HttpResultMode>> {
        return httpServer.rx.request(.userBrief(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    
    internal func deliveryHistory() -> Observable<[DeliveryJobsModel]>{
        return httpServer.rx.request(.delivery).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapArray(DeliveryJobsModel.self, tag: "body")
    }
    
    internal func deliveryHistoryStatus(jobId:String, type:String) -> Observable<[DeliveryHistoryStatus]> {
        return httpServer.rx.request(.deliveryStatus(jobId: jobId, type: type)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapArray(DeliveryHistoryStatus.self, tag: "body")
    }
    
    
    internal func getOnlineApplyId(positionId:String) -> Observable<ResponseModel<OnlineApplyId>>{
        return httpServer.rx.request(.getOnlineApplyId(positionId: positionId)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<OnlineApplyId>.self)
    }
    
    internal func resumelist() -> Observable<[ReumseListModel]>{
        
        return httpServer.rx.request(.resumeList).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapArray(ReumseListModel.self, tag: "body")
    }
    
    internal func newTextResume() -> Observable<ResponseModel<ReumseListModel>>{
        return httpServer.rx.request(.newTextResume).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<ReumseListModel>.self)
    }
    
    internal func newAttachResume(data:Data, name:String) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.newAttachResume(fileData: data, name: name)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func newResumeName(resumeId:String, name:String) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.changeResumeName(resumeId: resumeId, name: name)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func setPrimaryResume(resumeId:String) -> Observable<ResponseModel<HttpResultMode>> {
        return httpServer.rx.request(.primaryResume(resumeId: resumeId)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func deleteResume(resumeId:String, type:String) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.deleteResume(resumeId: resumeId, type: type)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func textResumeInfo(resumeId:String) -> Observable<ResponseModel<PersonTextResumeModel>>{
        
        return httpServer.rx.request(.textResumeInfo(resumeId: resumeId)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<PersonTextResumeModel>.self)
        
    }
    
    internal func baseInfoAvatar(resumeId:String, data:Data, name:String) -> Observable<ResponseModel<HttpAvatarResModel>>{
        return httpServer.rx.request(.baseInfoAvatar(resumeId: resumeId, data: data, name: name)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpAvatarResModel>.self)
    }
    
    internal func baseInfoContent(req: TextResumeBaseInfoReq) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.baseInfoContent(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func newResumeEducationInfo(req: TextResumeEducationReq) -> Observable<ResponseModel<ResumeSubItem>>{
        
        return httpServer.rx.request(.newTextResumeEducation(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<ResumeSubItem>.self)
    }
    
    
    internal func updateResumeEducation(id:String, req:TextResumeEducationReq) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.updateTextResumeEducation(id: id, req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func deleteResumeEducation(resumeId:String, id:String) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.deleteTextResumeEducation(resumeId: resumeId, id: id)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    
    
    
    internal func newResumeWorkInfo(req: TextResumeWorkReq) -> Observable<ResponseModel<ResumeSubItem>>{
        
        return httpServer.rx.request(.newTextResumeWork(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<ResumeSubItem>.self)
    }
    
    
    internal func updateResumeWork(id:String, req:TextResumeWorkReq) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.updateTextResumeWork(id: id, req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func deleteResumeWork(resumeId:String, id:String) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.deleteTextResumeWork(resumeId: resumeId, id: id)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    
    internal func newResumeProjectInfo(req: TextResumeProjectReq) -> Observable<ResponseModel<ResumeSubItem>>{
        
        return httpServer.rx.request(.newTextResumeProject(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<ResumeSubItem>.self)
    }
    
    
    internal func updateResumeProject(id:String, req:TextResumeProjectReq) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.updateTextResumeProject(id: id, req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func deleteResumeProject(resumeId:String, id:String) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.deleteTextResumeProject(resumeId: resumeId, id: id)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    
    
    internal func newResumeCollegeActiveInfo(req: TextResumeCollegeActiveReq) -> Observable<ResponseModel<ResumeSubItem>>{
        
        return httpServer.rx.request(.newTextResumeCollegeActive(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<ResumeSubItem>.self)
    }
    
    
    internal func updateResumeCollegeActive(id:String, req:TextResumeCollegeActiveReq) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.updateTextResumeCollegeActive(id: id, req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func deleteResumeCollegeActive(resumeId:String, id:String) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.deleteTextResumeCollegeActive(resumeId: resumeId, id: id)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    
    
    internal func newResumeSocialPracticeInfo(req: TextResumeSocialPracticeReq) -> Observable<ResponseModel<ResumeSubItem>>{
        
        return httpServer.rx.request(.newTextResumeSocialPractice(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<ResumeSubItem>.self)
    }
    
    
    internal func updateResumeSocialPractice(id:String, req:TextResumeSocialPracticeReq) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.updateTextResumeSocialPractice(id: id, req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func deleteResumeSocialPractice(resumeId:String, id:String) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.deleteTextResumeSocialPractice(resumeId: resumeId, id: id)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    
    
    internal func newResumeSkillInfo(req: TextResumeSkillReq) -> Observable<ResponseModel<ResumeSubItem>>{
        
        return httpServer.rx.request(.newTextResumeSkill(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<ResumeSubItem>.self)
    }
    
    
    internal func updateResumeSkill(id:String, req:TextResumeSkillReq) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.updateTextResumeSkill(id: id, req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func deleteResumeSkill(resumeId:String, id:String) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.deleteTextResumeSkill(resumeId: resumeId, id: id)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    
    
    
    internal func newResumeOtherInfo(req: TextResumeOtherReq) -> Observable<ResponseModel<ResumeSubItem>>{
        
        return httpServer.rx.request(.newTextResumeOther(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<ResumeSubItem>.self)
    }
    
    
    internal func updateResumeOther(id:String, req:TextResumeOtherReq) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.updateTextResumeOther(id: id, req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func deleteResumeOther(resumeId:String, id:String) -> Observable<ResponseModel<HttpResultMode>>{
        return httpServer.rx.request(.deleteTextResumeOther(resumeId: resumeId, id: id)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    
    internal func updateResumEstimate(id:String, req: TextResumeEstimateReq) -> Observable<ResponseModel<HttpResultMode>>{
        
        return httpServer.rx.request(.updateTextResumeEstimate(id: id, req: req))
            .retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    internal func attachResumeUrl(resumeId:String) -> Observable<ResponseModel<AttachResumRes>>{
        return httpServer.rx.request(.attachResume(resumeId: resumeId)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<AttachResumRes>.self)
    }
    
    
    
    
    
    
    
}
