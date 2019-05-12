//
//  recruitViewModel.swift
//  internals
//
//  Created by ke.liang on 2018/9/14.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa



class RecruitViewModel{
    
    
    private let dispose = DisposeBag()
    
    internal let onlineApplyRefresh:PublishSubject<OnlineFilterReqModel> = PublishSubject<OnlineFilterReqModel>.init()
    internal let onlineApplyRes:BehaviorRelay<[OnlineApplyListModel]> = BehaviorRelay<[OnlineApplyListModel]>.init(value: [])
    internal let onlineApplyRefreshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    internal var onlineApplyPullDown = false
    
    
    internal let internRefresh:PublishSubject<InternFilterModel> = PublishSubject<InternFilterModel>.init()
    internal let internRes:BehaviorRelay<[JobListModel]> = BehaviorRelay<[JobListModel]>.init(value: [])
    internal let internRefreshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    internal var internPullDown = false
    
    
    
    internal let graduateRefresh:PublishSubject<GraduateFilterModel> = PublishSubject<GraduateFilterModel>.init()
    internal let graduateRes:BehaviorRelay<[JobListModel]> = BehaviorRelay<[JobListModel]>.init(value: [])
    internal let graduateRefreshStasu:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    internal var graduatePullDown = false
    
    
    
    internal let recruitMeetingRefresh:PublishSubject<CareerTalkFilterModel> = PublishSubject<CareerTalkFilterModel>.init()
    internal let recruitMeetingRes:BehaviorRelay<[CareerTalkMeetingListModel]> = BehaviorRelay<[CareerTalkMeetingListModel]>.init(value: [])
    internal let recruitMeetingRefreshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    internal var recruitMeetingPullDown = false
    
    
    internal let companyRecruitMeetingRes:BehaviorRelay<[CareerTalkMeetingListModel]> = BehaviorRelay<[CareerTalkMeetingListModel]>.init(value: [])
    internal let companyRecruitMeetingRefesh:PublishSubject<CompanyRecruitMeetingFilterModel> = PublishSubject<CompanyRecruitMeetingFilterModel>.init()
    internal var companyRecruitMeetingPullDown = false
    // 内部刷新状态
    internal let companyRecruitMeetingRefeshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    
    
    
    internal let companyRefresh:PublishSubject<CompanyFilterModel> = PublishSubject<CompanyFilterModel>.init()
    internal let companyRes:BehaviorRelay<[CompanyListModel]> = BehaviorRelay<[CompanyListModel]>.init(value: [])
    internal let companyRefreshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    internal var companyPullDown = false
    
    
    
    //company list jobs
    internal let combinationlistRefresh:PublishSubject<CompanyTagFilterModel> = PublishSubject<CompanyTagFilterModel>.init()
    
    internal let combinationlistRes:BehaviorRelay<[CompanyTagJobs]> = BehaviorRelay<[CompanyTagJobs]>.init(value: [])
   // private var  tmpCombinatiobs:ListJobsOnlineAppy = ListJobsOnlineAppy(JSON: [:])!
    internal let combinationlistRefreshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    internal var combinationPullDown = false
    
    
    // jobs multi-section
    internal var jobMultiSection:BehaviorRelay<[JobMultiSectionModel]> = BehaviorRelay<[JobMultiSectionModel]>.init(value: [])
 
    // hr multi-section
    internal var recruiterMultiSection: BehaviorRelay<[RecruiterSectionModel]> =
        BehaviorRelay<[RecruiterSectionModel]>.init(value: [])
    // hr mode
    internal var recruiterMode: PublishRelay<HRPersonModel> = PublishRelay<HRPersonModel>.init()
  
    // recruit meeting multi-section
    internal var recruitMeetingMultiSection: BehaviorRelay<[RecruitMeetingSectionModel]> = BehaviorRelay<[RecruitMeetingSectionModel]>.init(value: [])
    
    private let httpServer:RecruitServer =  RecruitServer.shared
    
    
    
    init() {
        
        onlineApply()
        internJobs()
        graduateJobs()
        recruitMeeting()
        company()
        
        //公司职位和网申数据
        companyCombination()
        //公司宣讲会数据
        companyRecruitMeeting()
    }
    
    
}


extension RecruitViewModel{
    
   
    
    
    internal func getOnlineApplyBy(id: String) -> Observable<ResponseModel<OnlineApplyModel>>{
        return httpServer.getOnlineApplyId(id:id)
    }
    
    
  
    
    internal func getJobById(id:String, type: jobType){
        
            httpServer.getJobById(id: id, type: type).share().flatMapLatest { (res) -> Observable<[JobMultiSectionModel]> in
            
            guard  let job = res.body , HttpCodeRange.filterSuccessResponse(target: res.code ?? -1) else {
                return Observable<[JobMultiSectionModel]>.just([])
            }
            
            
            var sections:[JobMultiSectionModel] = []
            if let company = job.company{
                sections.append(JobMultiSectionModel.CompanySection(title: "", items: [JobSectionItem.CompanySectionItem(mode:company)]))
            }
            if let hr = job.recruiter{
                sections.append(JobMultiSectionModel.HRSection(title: "", items: [JobSectionItem.HRSectionItem(mode: hr)]))
            }
            sections.append(JobMultiSectionModel.JobDescribeSection(title: "", items: [JobSectionItem.JobDescribeSectionItem(mode: job)]))
            
            if  job.address.count > 0{
                sections.append(JobMultiSectionModel.AddressSection(title: "", items: [JobSectionItem.AddressSectionItem(adress: job.address)]))
            }
            
            if !job.endTime.isEmpty{
                sections.append(JobMultiSectionModel.EndTimeSection(title: "", items: [JobSectionItem.EndTimeSectionItem(time: job.endTime)]))
            }
        
            return Observable<[JobMultiSectionModel]>.just(sections)
            
            
        }.asDriver(onErrorJustReturn: []).drive(jobMultiSection).disposed(by: self.dispose)
        
    }
    
    
    internal func getRecruitMeetingBy(id:String){
        
        httpServer.getRecruitMeetingById(id:id).flatMapLatest { res -> Observable<[RecruitMeetingSectionModel]> in
            guard let body = res.body, HttpCodeRange.filterSuccessResponse(target: res.code ?? -1) else {
                return Observable<[RecruitMeetingSectionModel]>.just([])
            }
            var sections:[RecruitMeetingSectionModel] = []
            if let company = body.company{
                sections.append(RecruitMeetingSectionModel.CompanySection(title: "", items: [RecruitMeetingSectionItem.CompanyItem(mode: company)]))
            }
            sections.append(RecruitMeetingSectionModel.RecruitMeetingSection(title: "", items: [RecruitMeetingSectionItem.RecruitMeeting(mode: body)]))
            
            return Observable<[RecruitMeetingSectionModel]>.just(sections)
            
        }.asDriver(onErrorJustReturn: []).drive(self.recruitMeetingMultiSection).disposed(by: self.dispose)
    }
    
    
    
    internal func getCompanyById(id:String) -> Observable<ResponseModel<CompanyModel>>{
        return httpServer.getCompanyById(id:id)
    }

    
   
 
    
    // 获取recruiter 关联信息
    internal func getRecruiterById(id:String){
        
        self.httpServer.getRecruiterById(id: id).flatMapLatest { res -> Observable<[RecruiterSectionModel]> in
            
            guard  HttpCodeRange.filterSuccessResponse(target: res.code ?? -1), let body = res.body else{
                return Observable<[RecruiterSectionModel]>.just([])
            }
            
            var sections:[RecruiterSectionModel] = []
            if let recruiter = body.recruiter {
                // table header 数据
                self.recruiterMode.accept(recruiter)
            }
            // section 1
            if let company = body.company{
                sections.append(RecruiterSectionModel.CompanySection(title: "", items: [RecruiterSectionItem.CompanyItem(mode: company)]))
            }
            // section 2
            sections.append(RecruiterSectionModel.LabelSection(title: "", items: [RecruiterSectionItem.Label(mode: "发布的职位")]))
            
            if let jobs = body.jobs{
                
                var items:[RecruiterSectionItem] = []
                for j in jobs{
                    items.append(RecruiterSectionItem.JobItem(mode: j))
                }
                sections.append(RecruiterSectionModel.JobsSection(title: "", items: items))
            }
            return Observable<[RecruiterSectionModel]>.just(sections)
            
        }.asDriver(onErrorJustReturn: []).drive(recruiterMultiSection).disposed(by: self.dispose)
    }
    
    
    internal func jubao(){
        
    }

    
    
}


extension RecruitViewModel{
    
    private func onlineApply(){
        
       
        onlineApplyRefresh.do(onNext: { req in
            self.onlineApplyPullDown = req.offset == 0 ? true : false
        }).debug().flatMapLatest {  req in
            
            self.httpServer.getOnlineApply(req: req).asDriver(onErrorJustReturn: [])
            
            }.subscribe(onNext: {  [weak self] (modes) in
                guard let `self` = self else {
                    return
                }
                // 下拉刷新没有数据
                if modes.isEmpty &&  self.onlineApplyPullDown == false{
                    
                    self.onlineApplyRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                // 下拉刷新
                if  self.onlineApplyPullDown {
                    self.onlineApplyRes.accept(modes)
                    self.onlineApplyRefreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
                }else{
                    self.onlineApplyRes.accept(self.onlineApplyRes.value + modes)
                    self.onlineApplyRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)
                }
                
            }, onError:{ [weak self] err in
                self?.onlineApplyRefreshStatus.onNext(PageRefreshStatus.error(err: err))
            }).disposed(by: self.dispose)
        
        
    }
    
    
    private func internJobs(){
        
        internRefresh.do(onNext: { req in
            self.internPullDown = req.offset == 0 ? true : false
        }).flatMapLatest { req in
            self.httpServer.getInternJobs(req: req).asDriver(onErrorJustReturn: [])
            }.subscribe(onNext: { [weak self] (modes) in
                guard let `self` = self else {
                    return
                }
                
                if modes.isEmpty && self.internPullDown == false{
                    self.internRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if self.internPullDown{
                    self.internRes.accept(modes)
                    self.internRefreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
                }else{
                    self.internRes.accept(self.internRes.value + modes)
                    self.internRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)
                }
                
            }).disposed(by: self.dispose)
        
        
    }
    
    private func graduateJobs(){
        
        graduateRefresh.do(onNext: { req in
            self.graduatePullDown = req.offset == 0 ? true : false
        }).flatMapLatest { req in
            self.httpServer.getGraduateJobs(req: req).asDriver(onErrorJustReturn: [])
            }.subscribe(onNext: { [weak self] (modes) in
                guard let `self` = self else{
                    return
                }
                
                if modes.isEmpty && self.graduatePullDown == false {
                    self.graduateRefreshStasu.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if self.graduatePullDown{
                    self.graduateRes.accept(modes)
                    self.graduateRefreshStasu.onNext(PageRefreshStatus.endHeaderRefresh)
                }else{
                    self.graduateRes.accept(self.graduateRes.value + modes)
                    self.graduateRefreshStasu.onNext(PageRefreshStatus.endFooterRefresh)
                }
                
            }).disposed(by: self.dispose)
        
    }
    // 获取最新的meetings
    private func  recruitMeeting(){
        recruitMeetingRefresh.do(onNext: { [unowned self] (req) in
            
            self.recruitMeetingPullDown  =  req.offset == 0 ? true : false
        }).flatMapLatest { [unowned self] req in
            self.httpServer.getRecruiteMeetings(req: req).asDriver(onErrorJustReturn: [])
            }.subscribe(onNext: { [weak self] modes in
                guard let `self` = self else{
                    return
                }
                
                if modes.isEmpty && self.recruitMeetingPullDown == false {
                    self.recruitMeetingRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if self.recruitMeetingPullDown{
                    self.recruitMeetingRes.accept(modes)
                    self.recruitMeetingRefreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
                }else{
                    self.recruitMeetingRes.accept(self.recruitMeetingRes.value + modes)
                    self.recruitMeetingRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)
                }
                
            }).disposed(by: self.dispose)

    }
    
    //获取某个company 的meetings
    private func companyRecruitMeeting(){
        // MARK TODO ???
        
        self.companyRecruitMeetingRefesh.share().do(onNext: { (req) in
            self.companyRecruitMeetingPullDown = req.offset == 0 ? true : false
        }).flatMapLatest { (req)  in
               self.httpServer.getCompanyRecruitMeetings(req: req).asDriver(onErrorJustReturn: [])
            }.subscribe(onNext: { [weak self] (modes) in
                guard let `self` = self else {
                    return
                }
                if modes.isEmpty && self.companyRecruitMeetingPullDown == false {
                    self.companyRecruitMeetingRefeshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                
                if self.companyRecruitMeetingPullDown {
                    self.companyRecruitMeetingRefeshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
                    self.companyRecruitMeetingRes.accept(modes)
                }else{
                    self.companyRecruitMeetingRefeshStatus.onNext(PageRefreshStatus.endFooterRefresh)
                    self.companyRecruitMeetingRes.accept(self.companyRecruitMeetingRes.value + modes)
                }
                
                
            }).disposed(by: self.dispose)
    }
    
    
    private func company(){
        
        companyRefresh.do(onNext: { (req) in
            self.companyPullDown =  req.offset == 0 ? true : false
        }).flatMapLatest { req in
            self.httpServer.getCompany(req: req).asDriver(onErrorJustReturn: [])
            }.subscribe(onNext: { [weak self]  (modes) in
                guard let `self` = self else {
                    return
                }
                if modes.isEmpty && self.companyPullDown == false {
                    self.companyRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if self.companyPullDown{
                    self.companyRefreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
                    self.companyRes.accept(modes)
                }else{
                    self.companyRes.accept(self.companyRes.value + modes)
                    self.companyRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)
                }
            }).disposed(by: self.dispose)
    }
    
    
    private func companyCombination(){
        
        combinationlistRefresh.do(onNext: { (req) in
            //self.combinationPullDown =
            self.combinationPullDown = req.offset == 0 ? true : false
        }).flatMapLatest { req  in
            self.httpServer.getCompanyTagsData(req: req).asDriver(onErrorJustReturn: [])
            }.subscribe(onNext: { [weak self] (modes) in
                guard let `self` = self else{
                    return
                }
                if modes.isEmpty && self.combinationPullDown == false{
                    self.combinationlistRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if self.combinationPullDown{
                    self.combinationlistRes.accept(modes)
                self.combinationlistRefreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
                }else{
                    self.combinationlistRes.accept(self.combinationlistRes.value + modes)
                    self.combinationlistRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)
                }
            }).disposed(by: self.dispose)
    }
    
    
}







