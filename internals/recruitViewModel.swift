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
    internal let onlineApplyRes:BehaviorRelay<[OnlineApplyModel]> = BehaviorRelay<[OnlineApplyModel]>.init(value: [])
    internal let onlineApplyRefreshStatus:PublishSubject<mainPageRefreshStatus> = PublishSubject<mainPageRefreshStatus>.init()
    internal var onlineApplyOffset = 0
    
    
    internal let internRefresh:PublishSubject<Bool> = PublishSubject<Bool>.init()
    internal let internRes:BehaviorRelay<[CompuseRecruiteJobs]> = BehaviorRelay<[CompuseRecruiteJobs]>.init(value: [])
    internal let internRefreshStatus:PublishSubject<mainPageRefreshStatus> = PublishSubject<mainPageRefreshStatus>.init()
    internal var internOffset = 0
    
    
    
    internal let graduateRefresh:PublishSubject<Bool> = PublishSubject<Bool>.init()
    internal let graduateRes:BehaviorRelay<[CompuseRecruiteJobs]> = BehaviorRelay<[CompuseRecruiteJobs]>.init(value: [])
    internal let graduateRefreshStasu:PublishSubject<mainPageRefreshStatus> = PublishSubject<mainPageRefreshStatus>.init()
    internal var graduateOffset = 0
    
    
    
    internal let recruitMeetingRefresh:PublishSubject<Bool> = PublishSubject<Bool>.init()
    internal let companyRecruitMeetingRefesh:PublishSubject<(Bool, String)> = PublishSubject<(Bool, String)>.init()
    
    internal let recruitMeetingRes:BehaviorRelay<[CareerTalkMeetingModel]> = BehaviorRelay<[CareerTalkMeetingModel]>.init(value: [])
    internal let recruitMeetingRefreshStatus:PublishSubject<mainPageRefreshStatus> = PublishSubject<mainPageRefreshStatus>.init()
    internal var recruitMeetingOffset = 0 
    
    
    internal let companyRefresh:PublishSubject<Bool> = PublishSubject<Bool>.init()
    internal let companyRes:BehaviorRelay<[CompanyModel]> = BehaviorRelay<[CompanyModel]>.init(value: [])
    internal let companyRefreshStatus:PublishSubject<mainPageRefreshStatus> = PublishSubject<mainPageRefreshStatus>.init()
    internal var companyOffset = 0
    
    
    
    //company list jobs
    internal let combinationlistRefresh:PublishSubject<TagsDataItem> = PublishSubject<TagsDataItem>.init()
    
    
    
    //internal let combinationlistRes:BehaviorRelay<ListJobsOnlineAppy> = BehaviorRelay<ListJobsOnlineAppy>.init(value: ListJobsOnlineAppy(JSON: [:])!)
    
    internal let combinationlistRes:PublishSubject<ListJobsOnlineAppy> = PublishSubject<ListJobsOnlineAppy>.init()
    private var  tmpCombinatiobs:ListJobsOnlineAppy = ListJobsOnlineAppy(JSON: [:])!
    
    
    internal let combinationlistRefreshStatus:PublishSubject<mainPageRefreshStatus> = PublishSubject<mainPageRefreshStatus>.init()
    
    
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
    
    private func getOnlineApplies(offset: Int) -> Observable<[OnlineApplyModel]>{
        
        return httpServer.getOnlineApply(offset: offset).share()
    }
    
    internal func getOnlineApplyBy(id: String) -> Observable<OnlineApplyModel>{
        return httpServer.getOnlineApplyId(id:id)
    }
    
    
    private func getInternJobs(offset :Int) -> Observable<[CompuseRecruiteJobs]>{
        return httpServer.getInternJobs(offset: offset).share()
    }
    
    private func getGraduateJobs(offset:Int) -> Observable<[CompuseRecruiteJobs]>{
        
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
    
    private func getRecruitMeeting(offset:Int) -> Observable<[CareerTalkMeetingModel]>{
        
        return httpServer.getRecruiteMeetings(offset: offset)
    }
    
    
    internal func getRecruitMeetingBy(id:String) -> Observable<CareerTalkMeetingModel>{
        
        return httpServer.getRecruitMeetingById(id:id)
    }
    
    
    private func getCompany(offset:Int) ->Observable<[CompanyModel]>{
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
    
    private func getCompanyRecruitMeetings(companyId:String, offset:Int) -> Observable<[CareerTalkMeetingModel]>{
        return httpServer.getCompanyRecruitMeetings(companyId: companyId,offset: offset)
    }
    
    
}


extension RecruitViewModel{
    
    private func onlineApply(){
        
        onlineApplyRefresh.subscribe(onNext: { (IsPullDown) in
            self.onlineApplyOffset = IsPullDown ? 0 : self.onlineApplyOffset + 1
            
            self.getOnlineApplies(offset: self.onlineApplyOffset).subscribe(onNext: { (modes) in
                if modes.isEmpty{
                    self.onlineApplyRefreshStatus.onNext(mainPageRefreshStatus.NoMoreData)
                    return
                }
                if IsPullDown{
                    self.onlineApplyRes.accept(modes)
                    self.onlineApplyRefreshStatus.onNext(mainPageRefreshStatus.endHeaderRefresh)
                }else{
                    self.onlineApplyRes.accept(self.onlineApplyRes.value + modes)
                     self.onlineApplyRefreshStatus.onNext(mainPageRefreshStatus.endFooterRefresh)
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
                    self.internRefreshStatus.onNext(mainPageRefreshStatus.NoMoreData)
                    return
                }
                if IsPullDown{
                    self.internRes.accept(interns)
                    self.internRefreshStatus.onNext(mainPageRefreshStatus.endHeaderRefresh)
                }else{
                    self.internRes.accept(self.internRes.value + interns)
                    self.internRefreshStatus.onNext(mainPageRefreshStatus.endFooterRefresh)
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
                    self.graduateRefreshStasu.onNext(mainPageRefreshStatus.NoMoreData)
                    return
                }
                if IsPullDown{
                    self.graduateRes.accept(jobs)
                    self.graduateRefreshStasu.onNext(mainPageRefreshStatus.endHeaderRefresh)
                }else{
                    self.graduateRes.accept(self.graduateRes.value + jobs)
                    self.graduateRefreshStasu.onNext(mainPageRefreshStatus.endFooterRefresh)
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
                    self.recruitMeetingRefreshStatus.onNext(mainPageRefreshStatus.NoMoreData)
                    return
                }
                if IsPullDown{
                    self.recruitMeetingRes.accept(jobs)
                    self.recruitMeetingRefreshStatus.onNext(mainPageRefreshStatus.endHeaderRefresh)
                }else{
                    self.recruitMeetingRes.accept(self.recruitMeetingRes.value + jobs)
                    self.recruitMeetingRefreshStatus.onNext(mainPageRefreshStatus.endFooterRefresh)
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
                    self.recruitMeetingRefreshStatus.onNext(mainPageRefreshStatus.NoMoreData)
                    return
                }
                if IsPullDown{
                    self.recruitMeetingRes.accept(meetings)
                    self.recruitMeetingRefreshStatus.onNext(mainPageRefreshStatus.endHeaderRefresh)
                }else{
                    self.recruitMeetingRes.accept(self.recruitMeetingRes.value + meetings)
                    self.recruitMeetingRefreshStatus.onNext(mainPageRefreshStatus.endFooterRefresh)
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
                    self.companyRefreshStatus.onNext(mainPageRefreshStatus.NoMoreData)
                    return
                }
                
                if IsPullDown{
                    self.companyRes.accept(companys)
                    self.companyRefreshStatus.onNext(mainPageRefreshStatus.endHeaderRefresh)
                }else{
                    self.companyRes.accept(self.companyRes.value + companys)
                    self.companyRefreshStatus.onNext(mainPageRefreshStatus.endFooterRefresh)
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
                    self.combinationlistRefreshStatus.onNext(mainPageRefreshStatus.endHeaderRefresh)
                }else{
                
                    let tag = tagData.tag
                    if tag == "网申"{
                        if mode.onlineAppys.isEmpty{
                            self.combinationlistRefreshStatus.onNext(mainPageRefreshStatus.NoMoreData)
                            return
                        }else{
                            // 累加最新的数据
                            self.tmpCombinatiobs.onlineAppys.append(contentsOf: mode.onlineAppys)
                            self.combinationlistRes.onNext(self.tmpCombinatiobs)
                            self.combinationlistRefreshStatus.onNext(mainPageRefreshStatus.endFooterRefresh)
                        }
                    }else{
                        guard let tagJobs = mode.tagJobs[tag] else{
                            self.combinationlistRefreshStatus.onNext(mainPageRefreshStatus.NoMoreData)
                            return
                        }
                        if tagJobs.isEmpty{
                            self.combinationlistRefreshStatus.onNext(mainPageRefreshStatus.NoMoreData)
                            return
                        }else{
                             // 累加最新的数据
                            self.tmpCombinatiobs.tagJobs[tag]?.append(contentsOf: tagJobs)
                            self.combinationlistRes.onNext(self.tmpCombinatiobs)
                            self.combinationlistRefreshStatus.onNext(mainPageRefreshStatus.endFooterRefresh)
                        }
                    }
                    
                }
                
                
            }, onError: { (err) in
                self.combinationlistRefreshStatus.onNext(.error(err: err))
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        }).disposed(by: dispose)
    }
    
    
}







