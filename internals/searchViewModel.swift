//
//  searchViewModel.swift
//  internals
//
//  Created by ke.liang on 2017/12/11.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import RxDataSources



class searchViewModel {
    
    //网申
    let onlineApplyRrefresh:PublishSubject<(Bool, searchOnlineApplyBody)> = PublishSubject<(Bool, searchOnlineApplyBody)>()
    var onlineOffset = 0
    var onlineApplyStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>()
    var onlineApplyRes:BehaviorRelay<[OnlineApplyModel]> = BehaviorRelay<[OnlineApplyModel]>(value: [])
    
    //校招
    let graduateRefresh:PublishSubject<(Bool, searchGraduateRecruiteBody)> = PublishSubject<(Bool, searchGraduateRecruiteBody)>()
    var graduateOffset = 0
    var graduateRefreshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>()
    var graduateRes:BehaviorRelay<[JobListModel]> = BehaviorRelay<[JobListModel]>(value: [])
    
    
    //实习
    let internRefresh:PublishSubject<(Bool, searchInternJobsBody)> = PublishSubject<(Bool, searchInternJobsBody)>()
    var internOffset = 0
    var internRefreshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>()
    var internRes:BehaviorRelay<[JobListModel]> = BehaviorRelay<[JobListModel]>.init(value: [])
    
    // 宣讲会
    let careerTalkRefresh:PublishSubject<(Bool, searchCareerTalkBody)> = PublishSubject<(Bool, searchCareerTalkBody)>()
    var careerOffset = 0
    var careerRefreshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>()
    var carrerTalkRes:BehaviorRelay<[CareerTalkMeetingModel]> = BehaviorRelay<[CareerTalkMeetingModel]>.init(value: [])

    
    // 公司
    let companyRefresh:PublishSubject<(Bool, searchCompanyBody)> = PublishSubject<(Bool, searchCompanyBody)>()
    var companyOffset = 0
    var companyRefreshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>()
    var companyRes:BehaviorRelay<[CompanyModel]> = BehaviorRelay<[CompanyModel]>.init(value: [])
    
    
    
    let disposeBag = DisposeBag.init()
    let searchServer = SearchServer.shared
   

    
    init(){
        
        //网申数据
        setOnlineApply()
        // 校招数据
        setGraduateJobs()
        
        // 实习数据
        setInternJobs()
        
        // 宣讲会数据
        setCareerTalk()
        
        // 公司数据
        setCompany()
    }
    
    
    
    // onlineSearch
    
    // 搜索不同板块的 热门搜索记录
    func searchLatestHotRecord(type:String) -> Driver<[String]>{
        
        return searchServer.getTopWords(type: type).throttle(0.5, scheduler: MainScheduler.instance).asDriver(onErrorJustReturn: [])
        
    }
    
    func searchMatchWords(type:String, word:String) -> Observable<MatchKeyWordsModel>{
        
        return searchServer.getMatchedWords(type: type, word: word)
    }
    
    
    // 搜索不同类型 根据关键字查数据
    func searchOnlineAppy(mode:searchOnlineApplyBody, offset:Int) -> Observable<[OnlineApplyModel]>{
    
        return searchServer.searchOnlineAppy(mode: mode, offset: offset)
    }
    
    
    func searchGraduteJobs(mode: searchGraduateRecruiteBody, offset:Int) -> Observable<[JobListModel]>{
        
        return searchServer.searchGraduateJobs(mode:mode, offset: offset)
        
    }
    
    
    func searchInternJobs(mode: searchInternJobsBody, offset:Int) -> Observable<[JobListModel]>{
        
        return searchServer.searchInternJobs(mode: mode, offset: offset)
        
    }
    
    
    func searchCareerTalkMeetins(mode: searchCareerTalkBody, offset: Int) -> Observable<[CareerTalkMeetingModel]>{
        
        return searchServer.searchCareerTalkMeetins(mode: mode, offset: offset)
    }
    
    
    func searchCompany(mode: searchCompanyBody, offset:Int) -> Observable<[CompanyModel]>{
        return searchServer.searchCompany(mode: mode, offset:offset)
    }
    
    
}


extension searchViewModel{
    
    
    private func setOnlineApply(){
        // 网申数据
        onlineApplyRrefresh.subscribe(onNext: { (IsPullDown, mode) in
            
            self.onlineOffset =  IsPullDown ? 0 : self.onlineOffset + 1
            
            self.searchOnlineAppy(mode: mode, offset: self.onlineOffset).subscribe(onNext: { (modes) in
                if modes.isEmpty{
                    self.onlineApplyStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if IsPullDown{
                    self.onlineApplyRes.accept(modes)
                }else{
                    self.onlineApplyRes.accept(self.onlineApplyRes.value + modes)
                }
                
            }, onError: { (error) in
                self.onlineApplyStatus.onNext(.error(err: error))
                
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
            
            
            if IsPullDown{
                self.onlineApplyStatus.onNext(PageRefreshStatus.endHeaderRefresh)
                
            }else{
                self.onlineApplyStatus.onNext(PageRefreshStatus.endFooterRefresh)
            }
            
            
        }).disposed(by: disposeBag)
    }
    
    
    private func setGraduateJobs(){
        graduateRefresh.subscribe(onNext: { (IsPullDown, mode) in
            self.graduateOffset = IsPullDown ? 0 : self.graduateOffset + 1
            self.searchGraduteJobs(mode: mode, offset: self.graduateOffset).subscribe(onNext: { (jobs) in
                if jobs.isEmpty{
                    self.graduateRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if IsPullDown{
                    self.graduateRes.accept(jobs)
                }else{
                    self.graduateRes.accept(self.graduateRes.value + jobs)
                }
                
                
            }, onError: { (err) in
                self.graduateRefreshStatus.onNext(.error(err: err))
                
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
            
            
            if IsPullDown{
                self.graduateRefreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
            }else{
                self.graduateRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)

            }
            
            
            
        }).disposed(by: disposeBag)
    }
    
    
    private func setInternJobs(){
        
  
        internRefresh.share().subscribe(onNext: { (IsPullDown, mode) in
            self.internOffset = IsPullDown ? 0 : self.internOffset + 1
            
            self.searchInternJobs(mode: mode, offset: self.internOffset).subscribe(onNext: { jobs in
                if jobs.isEmpty{
                    self.internRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if IsPullDown{
                    self.internRes.accept(jobs)
                }else{
                    self.internRes.accept(self.internRes.value + jobs)
                }
                
            }, onError: { (err) in
                self.internRefreshStatus.onNext(.error(err: err))
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)

            if IsPullDown{
                self.internRefreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
            }else{
                self.internRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)
            }

        }).disposed(by: disposeBag)
        
    }
    
    
    private func  setCareerTalk(){
        careerTalkRefresh.share().subscribe(onNext: { (IsPullDown, mode) in
            self.careerOffset = IsPullDown ? 0 : self.careerOffset + 1
            self.searchCareerTalkMeetins(mode: mode, offset: self.careerOffset).subscribe(onNext: { meetings in
                if meetings.isEmpty{
                    self.careerRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if IsPullDown{
                    self.carrerTalkRes.accept(meetings)
                }else{
                    self.carrerTalkRes.accept(self.carrerTalkRes.value + meetings)
                }
                
            }, onError: { (err) in
                self.careerRefreshStatus.onNext(.error(err: err))
                
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
            
            if IsPullDown{
                self.careerRefreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
            }else{
                self.careerRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)
            }
            
        }).disposed(by: disposeBag)
    }
    
    
    private func  setCompany(){
        companyRefresh.share().subscribe(onNext: {(IsPullDown, mode) in
            self.companyOffset = IsPullDown ? 0 : self.companyOffset + 1
            self.searchCompany(mode: mode, offset: self.companyOffset).subscribe(onNext: { companys in
                if companys.isEmpty{
                    self.companyRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if IsPullDown{
                    self.companyRes.accept(companys)
                }else{
                    self.companyRes.accept(self.companyRes.value + companys)
                }
                
            }, onError: { (err) in
                self.companyRefreshStatus.onNext(.error(err: err))
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
            
            if IsPullDown{
                self.companyRefreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
            }else{
                self.companyRefreshStatus.onNext(PageRefreshStatus.endFooterRefresh)
            }
            
            
        }).disposed(by: disposeBag)
        
    }
    
}
