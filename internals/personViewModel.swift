//
//  personViewModel.swift
//  internals
//
//  Created by ke.liang on 2018/4/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PersonViewModel {
    
    
    static let shared: PersonViewModel = PersonViewModel.init()
    private lazy var dispose:DisposeBag = DisposeBag.init()
    private lazy var server: PersonServer = PersonServer.shared
    
    
    internal let loading: Driver<Bool>
    private let activityIndicator = ActivityIndicator()

    
    
    private init() {
        self.loading = activityIndicator.asDriver()
        
    }
    
    
    internal func updateAvatar(data:Data, name:String) -> Observable<ResponseModel<HttpAvatarResModel>>{
        return server.updateAvatar(data: data, name: name).trackActivity(self.activityIndicator)
    }
    
    internal func updateBrief(req: PersonBriefReq) -> Observable<ResponseModel<HttpResultMode>>{
        return server.updatePersonBrief(req: req).trackActivity(self.activityIndicator)
    }
    
    internal func deliveryHistoryJobs() -> Observable<[DeliveryJobsModel]>{
        return server.deliveryHistory()
    }
    
    internal func jobDeliveryHistoryStatus(jobId:String, type:String) -> Observable<[DeliveryHistoryStatus]>{
        return server.deliveryHistoryStatus(jobId: jobId, type: type).trackActivity(self.activityIndicator)
    }
    
    internal func getOnlineApplyId(positionId:String) -> Observable<ResponseModel<OnlineApplyId>>{
        return server.getOnlineApplyId(positionId: positionId)
    }
    
    internal func resumeList() -> Observable<[ReumseListModel]>{
        return server.resumelist()
    }
    
    internal func newResumeName(resumeId:String, name:String) -> Observable<ResponseModel<HttpResultMode>>{
        return server.newResumeName(resumeId: resumeId, name: name)
    }
    
    internal func newTextResume() -> Observable<ResponseModel<ReumseListModel>>{
        return server.newTextResume()
    }
    
    internal func newAttachResume(data:Data, name:String) -> Observable<ResponseModel<HttpResultMode>>{
        return server.newAttachResume(data: data, name: name)
    }
    internal func setPrimaryResume(resumeId:String) -> Observable<ResponseModel<HttpResultMode>>{
        return server.setPrimaryResume(resumeId: resumeId)
    }
    internal func deleteResume(resumeId:String, type: resumeType) -> Observable<ResponseModel<HttpResultMode>>{
        return server.deleteResume(resumeId: resumeId, type: type.rawValue)
    }
    
    internal func textResumeInfo(resumeId:String) -> Observable<ResponseModel<PersonTextResumeModel>>{
        return server.textResumeInfo(resumeId: resumeId)
    }
    
    internal func textResumeContent(req:TextResumeBaseInfoReq) -> Observable<ResponseModel<HttpResultMode>>{
        return server.baseInfoContent(req: req)
    }
    
    func textResuemBaseInfoAvatar(resumeId:String, data:Data, name:String) -> Observable<ResponseModel<HttpAvatarResModel>> {
        return server.baseInfoAvatar(resumeId: resumeId, data: data, name: name).trackActivity(self.activityIndicator)
    }
    
    
    func createTextResumeEducation(req: TextResumeEducationReq) -> Observable<ResponseModel<ResumeSubItem>>{
        return server.newResumeEducationInfo(req: req)
    }
    
    func updateTextResumeEducation(id:String, req: TextResumeEducationReq) -> Observable<ResponseModel<HttpResultMode>>{
        return server.updateResumeEducation(id: id, req: req)
    }
    
    func deleteTextResumeEducation(resumeId:String, id:String)  -> Observable<ResponseModel<HttpResultMode>>{
        return server.deleteResumeEducation(resumeId: resumeId, id: id)
    }
    
    
    internal func newResumeWorkInfo(req: TextResumeWorkReq) -> Observable<ResponseModel<ResumeSubItem>>{
        
        return server.newResumeWorkInfo(req: req)
    }
    
    
    internal func updateResumeWork(id:String, req:TextResumeWorkReq) -> Observable<ResponseModel<HttpResultMode>>{
        return  server.updateResumeWork(id: id, req: req)
    }
    
    internal func deleteResumeWork(resumeId:String, id:String) -> Observable<ResponseModel<HttpResultMode>>{
        return server.deleteResumeWork(resumeId: resumeId, id: id)
    }
    
    
    
    internal func newResumeProjectInfo(req: TextResumeProjectReq) -> Observable<ResponseModel<ResumeSubItem>>{
        
        return server.newResumeProjectInfo(req: req)
    }
    
    
    internal func updateResumeProject(id:String, req:TextResumeProjectReq) -> Observable<ResponseModel<HttpResultMode>>{
        return server.updateResumeProject(id: id, req: req)
    }
    
    internal func deleteResumeProject(resumeId:String, id:String) -> Observable<ResponseModel<HttpResultMode>>{
        return server.deleteResumeProject(resumeId: resumeId, id: id)
    }
    
    
    
    internal func newResumeCollegeActiveInfo(req: TextResumeCollegeActiveReq) -> Observable<ResponseModel<ResumeSubItem>>{
        
        return server.newResumeCollegeActiveInfo(req: req)
    }
    
    
    internal func updateResumeCollegeActive(id:String, req:TextResumeCollegeActiveReq) -> Observable<ResponseModel<HttpResultMode>>{
        return server.updateResumeCollegeActive(id: id, req: req)
    }
    
    internal func deleteResumeCollegeActive(resumeId:String, id:String) -> Observable<ResponseModel<HttpResultMode>>{
        return server.deleteResumeCollegeActive(resumeId: resumeId, id: id)
    }
    
    
    internal func newResumeSocialPracticeInfo(req: TextResumeSocialPracticeReq) -> Observable<ResponseModel<ResumeSubItem>>{
        
        return server.newResumeSocialPracticeInfo(req: req)
    }
    
    
    internal func updateResumeSocialPractice(id:String, req:TextResumeSocialPracticeReq) -> Observable<ResponseModel<HttpResultMode>>{
        return server.updateResumeSocialPractice(id: id, req: req)
    }
    
    internal func deleteResumeSocialPractice(resumeId:String, id:String) -> Observable<ResponseModel<HttpResultMode>>{
        return server.deleteResumeCollegeActive(resumeId: resumeId, id: id)
    }
    
    
    internal func newResumeSkillInfo(req: TextResumeSkillReq) -> Observable<ResponseModel<ResumeSubItem>>{
        
        return server.newResumeSkillInfo(req: req)
    }
    
    
    internal func updateResumeSkill(id:String, req:TextResumeSkillReq) -> Observable<ResponseModel<HttpResultMode>>{
        return server.updateResumeSkill(id: id, req: req)
    }
    
    internal func deleteResumeSkill(resumeId:String, id:String) -> Observable<ResponseModel<HttpResultMode>>{
        return server.deleteResumeSkill(resumeId: resumeId, id: id)
    }
    
    
    
    internal func newResumeOtherInfo(req: TextResumeOtherReq) -> Observable<ResponseModel<ResumeSubItem>>{
        
        return server.newResumeOtherInfo(req: req)
    }
    
    
    internal func updateResumeOther(id:String, req:TextResumeOtherReq) -> Observable<ResponseModel<HttpResultMode>>{
        return server.updateResumeOther(id: id, req: req)
    }
    
    internal func deleteResumeOther(resumeId:String, id:String) -> Observable<ResponseModel<HttpResultMode>>{
        return server.deleteResumeOther(resumeId: resumeId, id: id)
    }
    
    
    
    internal func updateResumEstimate(id:String, req: TextResumeEstimateReq) -> Observable<ResponseModel<HttpResultMode>>{
        
        return server.updateResumEstimate(id: id, req: req)
    }
    
    internal func attachResumeURL(resumeId:String) ->
        Observable<ResponseModel<AttachResumRes>> {
        return server.attachResumeUrl(resumeId: resumeId)
    }
    

    
}

class  personModelManager {
    
    
    static let shared: personModelManager = personModelManager()
    
    
    
    private lazy var currentResumeID:String = ""
    
    // 记录当前简历信息
    open var  mode:[String:ResumeMode] = [:]
    // 简历完整度
    open var integrity:Int = 0
    //test
    //var initialFirst = false
    private init(){}
    
    
    open func getOnlineResume(resumeID:String){
        // 从服务器湖获取数据
        self.currentResumeID = resumeID
       
        mode[currentResumeID] = ResumeMode(JSON: [
            "educationInfo":[],
            "internInfo":[],
            "skills":[],
            "projectInfo":[],
            "studentWorkInfo":[],
            "practiceInfo":[],
            "resumeOtherInfo":[],
            "estimate": EstimateTextResume(JSON: [:])?.toJSON() ?? [:]
            ])
        
        integrity = 58
        
        //initialFirst = true 
        
    }
    
    open func getAttachResume(resumeID:String){
        
    }
    
    open func getCountBy(type: ResumeSubItems) -> Int{
        switch type {
        case .education:
            return mode[currentResumeID]?.educationInfo.count ?? 0
        case .works:
            return mode[currentResumeID]?.internInfo.count ?? 0
        case .skills:
            return mode[currentResumeID]?.skills.count ?? 0
        case .project:
            return mode[currentResumeID]?.projectInfo.count ?? 0
        case .schoolWork:
            return mode[currentResumeID]?.studentWorkInfo.count ?? 0
        case .practice:
            return mode[currentResumeID]?.practiceInfo.count ?? 0
        case .other:
            return mode[currentResumeID]?.resumeOtherInfo.count ?? 0
        
        case .selfEvaludate:
            
            if let es =  mode[currentResumeID]?.estimate, !es.content.isEmpty{
                return 1
            }
            return 0
            
        default:
            return 0
        }
    }
    
    
    open func getDatas() -> [ResumeSubItems: Any?]{
        
        return [:]
//        return [ResumeSubItems.personInfo: resumeBaseinfo ,.education: mode[currentResumeID]?.educationInfo,
//                .works: mode[currentResumeID]?.internInfo, .project: mode[currentResumeID]?.projectInfo,.schoolWork: mode[currentResumeID]?.studentWorkInfo,
//                .practice:mode[currentResumeID]?.practiceInfo,.skills: mode[currentResumeID]?.skills,.other: mode[currentResumeID]?.resumeOtherInfo,
//                .selfEvaludate: mode[currentResumeID]?.estimate]
        
    }
    
    
    open func getItemBy(type: ResumeSubItems) -> Any?{
        
        switch type {
        case .education:
            return self.mode[currentResumeID]?.educationInfo
        case .works:
            return self.mode[currentResumeID]?.internInfo
        case .project:
            return self.mode[currentResumeID]?.projectInfo
        case .schoolWork:
            return self.mode[currentResumeID]?.studentWorkInfo
        case .practice:
            return self.mode[currentResumeID]?.practiceInfo
        case .skills:
            return self.mode[currentResumeID]?.skills
        case .other:
            return self.mode[currentResumeID]?.resumeOtherInfo
        case .selfEvaludate:
            return self.mode[currentResumeID]?.estimate
            
        default:
            return nil
        }
        
    }
    
    open func getEstimate() ->String{
        
        return mode[currentResumeID]?.estimate?.content ?? ""
    }
    
    open func setEstimate(text:String){
        mode[currentResumeID]?.estimate?.content = text
    }
    
    open func sortByEndTime(type: ResumeSubItems){
        
        let timeFormat = "yyyy-MM"
        guard  let mode = mode[currentResumeID]  else {
            return
        }
        switch type {
        case .education:
            guard  mode.educationInfo.count > 1  else { return }
            mode.educationInfo.sort { (p1, p2) -> Bool in
            
                return p1.endTimeString.getTimeInterval(format: timeFormat) > p2.endTimeString.getTimeInterval(format: timeFormat)
            }
        case .works:
            guard   mode.internInfo.count > 1 else { return }
            mode.internInfo.sort { (p1, p2) -> Bool in
            
                return p1.endTimeString.getTimeInterval(format: timeFormat) > p2.endTimeString.getTimeInterval(format: timeFormat)

            }
            
        case .project:
            guard  mode.projectInfo.count > 1 else { return }
            mode.projectInfo.sort { (p1, p2) -> Bool in
                
                return p1.endTimeString.getTimeInterval(format: timeFormat) > p2.endTimeString.getTimeInterval(format: timeFormat)
                
            }
        
        case .schoolWork:
            guard mode.studentWorkInfo.count > 1 else { return }
            mode.studentWorkInfo.sort { (p1, p2) -> Bool in
                
                return p1.endTimeString.getTimeInterval(format: timeFormat) > p2.endTimeString.getTimeInterval(format: timeFormat)
                
            }
        case .practice:
            guard  mode.practiceInfo.count > 1 else { return }
            mode.practiceInfo.sort { (p1, p2) -> Bool in
                
                return p1.endTimeString.getTimeInterval(format: timeFormat) > p2.endTimeString.getTimeInterval(format: timeFormat)
                
            }
        default:
            break
        }
    }
    
    open func addItemBy(itemType:ResumeSubItems,res:[String:Any]){
        
        switch itemType {
        case .education:
            
            if let mode = educationInfoTextResume(JSON: res){
                self.mode[currentResumeID]?.educationInfo.append(mode)
            }
            
            
        case .works:
            
            if let mode = workInfoTextResume(JSON: res){
                 self.mode[currentResumeID]?.internInfo.append(mode)
            }
            
        case .project:
            if let mode = ProjectInfoTextResume(JSON: res){
                 self.mode[currentResumeID]?.projectInfo.append(mode)
            }
            
        case .schoolWork:
            if let mode = CollegeActivityTextResume(JSON: res){
                 self.mode[currentResumeID]?.studentWorkInfo.append(mode)
            }
        case .practice:
            if  let mode = SocialPracticeTextResume(JSON: res){
                 self.mode[currentResumeID]?.practiceInfo.append(mode)
            }
            
        case .skills:
            if  let mode = SkillsTextResume(JSON: res){
                 self.mode[currentResumeID]?.skills.append(mode)
            }
        case .other:
            if let mode = OtherTextResume(JSON: res){
                 self.mode[currentResumeID]?.resumeOtherInfo.append(mode)
            }
            
        default:
            break
        }
    }
    
    
    open func modifyItemBy(type:ResumeSubItems, row:Int, res:[String:Any]){
        
        switch  type {
        case .education:
            if let data = educationInfoTextResume(JSON: res){
                
                self.mode[currentResumeID]?.educationInfo[row] = data
            }
        case .works:
            if let data = workInfoTextResume(JSON: res){
                self.mode[currentResumeID]?.internInfo[row] = data
                
            }
            
        case .project:
            if let data = ProjectInfoTextResume(JSON: res){
                self.mode[currentResumeID]?.projectInfo[row] = data
            }
            
        case .practice:
            if  let data = SocialPracticeTextResume(JSON: res){
                self.mode[currentResumeID]?.practiceInfo[row] = data
            }
            
        case .other:
            if let data = OtherTextResume(JSON: res){
                self.mode[currentResumeID]?.resumeOtherInfo[row] = data
            }
            
        case .schoolWork:
            if let data = CollegeActivityTextResume(JSON: res){
                self.mode[currentResumeID]?.studentWorkInfo[row] = data
            }
            
        case .skills:
            if  let data = SkillsTextResume(JSON: res){
                self.mode[currentResumeID]?.skills[row] = data
            }
            
        default:
            break
        }
    }
    
    
    open func deleteItemBy(type:ResumeSubItems, row:Int){
        
        switch  type {
        case .education:
            self.mode[currentResumeID]?.educationInfo.remove(at: row)
        case .works:
            self.mode[currentResumeID]?.internInfo.remove(at: row)
        case .project:
            self.mode[currentResumeID]?.projectInfo.remove(at: row)
        case .practice:
            self.mode[currentResumeID]?.practiceInfo.remove(at: row)
        case .other:
            self.mode[currentResumeID]?.resumeOtherInfo.remove(at: row)
        case .schoolWork:
            self.mode[currentResumeID]?.studentWorkInfo.remove(at: row)
        case .skills:
            self.mode[currentResumeID]?.skills.remove(at: row)
        default:
            break
        }
    }
    
}
