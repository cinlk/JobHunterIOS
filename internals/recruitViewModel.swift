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
    internal let onlineApplyRefresh:PublishSubject<Bool> = PublishSubject<Bool>.init()
    internal let onlineApplyRes:BehaviorRelay<[OnlineApplyListModel]> = BehaviorRelay<[OnlineApplyListModel]>.init(value: [])
    internal let onlineApplyRefreshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    internal var onlineApplyOffset = 0
    
    
    internal let internRefresh:PublishSubject<Bool> = PublishSubject<Bool>.init()
    internal let internRes:BehaviorRelay<[JobListModel]> = BehaviorRelay<[JobListModel]>.init(value: [])
    internal let internRefreshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    internal var internOffset = 0
    
    
    
    internal let graduateRefresh:PublishSubject<Bool> = PublishSubject<Bool>.init()
    internal let graduateRes:BehaviorRelay<[JobListModel]> = BehaviorRelay<[JobListModel]>.init(value: [])
    internal let graduateRefreshStasu:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    internal var graduateOffset = 0
    
    
    
    internal let recruitMeetingRefresh:PublishSubject<Bool> = PublishSubject<Bool>.init()
    internal let companyRecruitMeetingRefesh:PublishSubject<(Bool, String)> = PublishSubject<(Bool, String)>.init()
    
    internal let recruitMeetingRes:BehaviorRelay<[CareerTalkMeetingListModel]> = BehaviorRelay<[CareerTalkMeetingListModel]>.init(value: [])
    internal let recruitMeetingRefreshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    internal var recruitMeetingOffset = 0 
    
    
    internal let companyRefresh:PublishSubject<Bool> = PublishSubject<Bool>.init()
    internal let companyRes:BehaviorRelay<[CompanyListModel]> = BehaviorRelay<[CompanyListModel]>.init(value: [])
    internal let companyRefreshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    internal var companyOffset = 0
    
    
    
    //company list jobs
    internal let combinationlistRefresh:PublishSubject<TagsDataItem> = PublishSubject<TagsDataItem>.init()
    
    
    
    //internal let combinationlistRes:BehaviorRelay<ListJobsOnlineAppy> = BehaviorRelay<ListJobsOnlineAppy>.init(value: ListJobsOnlineAppy(JSON: [:])!)
    
    internal let combinationlistRes:PublishSubject<ListJobsOnlineAppy> = PublishSubject<ListJobsOnlineAppy>.init()
    private var  tmpCombinatiobs:ListJobsOnlineAppy = ListJobsOnlineAppy(JSON: [:])!
    
    
    internal let combinationlistRefreshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    
    
    // jobs multi-section
    //internal var SingleJob:PublishSubject<CompuseRecruiteJobs> = PublishSubject<CompuseRecruiteJobs>.init()
    internal var jobMultiSection:Driver<[JobMultiSectionModel]> = Driver<[JobMultiSectionModel]>.just([])
 
    
    
    let httpServer:RecruitServer =  RecruitServer.shared
    
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
    
    private func getOnlineApplies(offset: Int) -> Observable<[OnlineApplyListModel]>{
        
        return httpServer.getOnlineApply(offset: offset).share()
    }
    
    internal func getOnlineApplyBy(id: String) -> Observable<OnlineApplyModel>{
        return httpServer.getOnlineApplyId(id:id)
    }
    
    
    private func getInternJobs(offset :Int) -> Observable<[JobListModel]>{
        return httpServer.getInternJobs(offset: offset).share()
    }
    
    private func getGraduateJobs(offset:Int) -> Observable<[JobListModel]>{
        
        return httpServer.getGraduateJobs(offset: offset).share()
    }
    
   internal func getJobById(id:String){
        
           jobMultiSection =  httpServer.getJobById(id: id).share().flatMapLatest { (job) -> Observable<[JobMultiSectionModel]> in
            
            
            
            var sections:[JobMultiSectionModel] = []
            if let company = job.company{
                sections.append(JobMultiSectionModel.CompanySection(title: "", items: [JobSectionItem.CompanySectionItem(mode:company)]))
            }
            if let hr = job.hr{
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
            
            
        }.asDriver(onErrorJustReturn: [])
        
    }
    
    private func getRecruitMeeting(offset:Int) -> Observable<[CareerTalkMeetingListModel]>{
        
        
        return httpServer.getRecruiteMeetings(offset: offset)
    }
    
    
    internal func getRecruitMeetingBy(id:String) -> Observable<CareerTalkMeetingModel>{
        
        return httpServer.getRecruitMeetingById(id:id)
    }
    
    
    private func getCompany(offset:Int) ->Observable<[CompanyListModel]>{
        return httpServer.getCompany(offset: offset)
    }
    
    internal func getCompanyById(id:String) -> Observable<CompanyModel>{
        return httpServer.getCompanyById(id:id)
    }

    
    
    internal func getJobWarnMessages() -> Observable<[String]>{
        return httpServer.getJobWarnMessage()
    }
    
    private func getCompanyTagsData(data:TagsDataItem) -> Observable<ListJobsOnlineAppy>{
        return httpServer.getCompanyTagsData(data: data)
    }
    
    private func getCompanyRecruitMeetings(companyId:String, offset:Int) -> Observable<[CareerTalkMeetingListModel]>{
        return httpServer.getCompanyRecruitMeetings(companyId: companyId,offset: offset)
    }
    
    
}


extension RecruitViewModel{
    
    private func onlineApply(){
        
        onlineApplyRefresh.subscribe(onNext: { (IsPullDown) in
            self.onlineApplyOffset = IsPullDown ? 0 : self.onlineApplyOffset + 1
            
            self.getOnlineApplies(offset: self.onlineApplyOffset).subscribe(onNext: { (modes) in
                if modes.isEmpty{
                    self.onlineApplyRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if IsPullDown{
                    self.onlineApplyRes.accept(modes)
                    self.onlineApplyRefreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
                }else{
                    self.onlineApplyRes.accept(self.onlineApplyRes.value + modes)
                     self.onlineApplyRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)
                }
                
            }, onError: { (err) in
                self.onlineApplyRefreshStatus.onNext(.error(err: err))
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        }).disposed(by: dispose)
    }
    
    
    private func internJobs(){
        
        internRefresh.subscribe(onNext: { (IsPullDown) in
            
            self.internOffset = IsPullDown ? 0 : self.internOffset + 1
            self.getInternJobs(offset: self.internOffset).subscribe(onNext: { (interns) in
                if interns.isEmpty {
                    self.internRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if IsPullDown{
                    self.internRes.accept(interns)
                    self.internRefreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
                }else{
                    self.internRes.accept(self.internRes.value + interns)
                    self.internRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)
                }
                
            }, onError: { (err) in
                self.internRefreshStatus.onNext(.error(err: err))
                
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        }).disposed(by: dispose)
        
        
    }
    
    private func graduateJobs(){
        graduateRefresh.subscribe(onNext: { (IsPullDown) in
            self.graduateOffset = IsPullDown ? 0 : self.graduateOffset + 1
            
            self.getGraduateJobs(offset: self.graduateOffset).subscribe(onNext: { (jobs) in
                if jobs.isEmpty{
                    self.graduateRefreshStasu.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if IsPullDown{
                    self.graduateRes.accept(jobs)
                    self.graduateRefreshStasu.onNext(PageRefreshStatus.endHeaderRefresh)
                }else{
                    self.graduateRes.accept(self.graduateRes.value + jobs)
                    self.graduateRefreshStasu.onNext(PageRefreshStatus.endFooterRefresh)
                }
                
            }, onError: { (err) in
                self.graduateRefreshStasu.onNext(.error(err: err))
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
            
        }).disposed(by: dispose)
    }
    // 获取最新的meetings
    private func  recruitMeeting(){
        
        recruitMeetingRefresh.subscribe(onNext: { (IsPullDown) in
            self.recruitMeetingOffset = IsPullDown ? 0 : self.recruitMeetingOffset + 1
            
            self.getRecruitMeeting(offset: self.recruitMeetingOffset).subscribe(onNext: { (jobs) in
                if jobs.isEmpty{
                    self.recruitMeetingRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if IsPullDown{
                    self.recruitMeetingRes.accept(jobs)
                    self.recruitMeetingRefreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
                }else{
                    self.recruitMeetingRes.accept(self.recruitMeetingRes.value + jobs)
                    self.recruitMeetingRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)
                }
                
            }, onError: { (err) in
                self.recruitMeetingRefreshStatus.onNext(.error(err: err))
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
            
        }).disposed(by: dispose)
    }
    
    //获取某个company 的meetings
    private func companyRecruitMeeting(){
        companyRecruitMeetingRefesh.debug().subscribe(onNext: { (IsPullDown, companyID) in
            self.recruitMeetingOffset = IsPullDown ? 0 : self.recruitMeetingOffset + 1
            self.getCompanyRecruitMeetings(companyId: companyID, offset: self.recruitMeetingOffset).subscribe(onNext: { (meetings) in
                if meetings.isEmpty{
                    self.recruitMeetingRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if IsPullDown{
                    self.recruitMeetingRes.accept(meetings)
                    self.recruitMeetingRefreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
                }else{
                    self.recruitMeetingRes.accept(self.recruitMeetingRes.value + meetings)
                    self.recruitMeetingRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)
                }
                
            }, onError: { (err) in
                self.recruitMeetingRefreshStatus.onNext(.error(err: err))
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        }).disposed(by: dispose)
    }
    
    
    private func company(){
        companyRefresh.subscribe(onNext: { (IsPullDown) in
            self.companyOffset = IsPullDown ? 0 : self.companyOffset + 1
            self.getCompany(offset: self.companyOffset).subscribe(onNext: { (companys) in
                if companys.isEmpty{
                    self.companyRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                
                if IsPullDown{
                    self.companyRes.accept(companys)
                    self.companyRefreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
                }else{
                    self.companyRes.accept(self.companyRes.value + companys)
                    self.companyRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)
                }
            }, onError: { (err) in
                self.companyRefreshStatus.onNext(.error(err: err))
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
            
        }).disposed(by: dispose)
    }
    
    
    private func companyCombination(){
        
        combinationlistRefresh.subscribe(onNext: { (tagData) in
            // 获取所有tag数据
            self.getCompanyTagsData(data: tagData).share().subscribe(onNext: { (mode) in
              
                if tagData.isPullDown{
                    self.tmpCombinatiobs = mode
                    self.combinationlistRes.onNext(self.tmpCombinatiobs)
                    //self.combinationlistRes.accept(mode)
                    // 在界面 计算当前的offset 值状态
                    self.combinationlistRefreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
                }else{
                
                    let tag = tagData.tag
                    if tag == "网申"{
                        if mode.onlineAppys.isEmpty{
                            self.combinationlistRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                            return
                        }else{
                            // 累加最新的数据
                            self.tmpCombinatiobs.onlineAppys.append(contentsOf: mode.onlineAppys)
                            self.combinationlistRes.onNext(self.tmpCombinatiobs)
                            self.combinationlistRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)
                        }
                    }else{
                        guard let tagJobs = mode.tagJobs[tag] else{
                            self.combinationlistRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                            return
                        }
                        if tagJobs.isEmpty{
                            self.combinationlistRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                            return
                        }else{
                             // 累加最新的数据
                            self.tmpCombinatiobs.tagJobs[tag]?.append(contentsOf: tagJobs)
                            self.combinationlistRes.onNext(self.tmpCombinatiobs)
                            self.combinationlistRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)
                        }
                    }
                    
                }
                
                
            }, onError: { (err) in
                self.combinationlistRefreshStatus.onNext(.error(err: err))
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        }).disposed(by: dispose)
    }
    
    
}







