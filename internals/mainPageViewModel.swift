//
//  mainPageViewModel.swift
//  internals
//
//  Created by ke.liang on 2017/11/25.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import ObjectMapper

// 刷新状态
enum mainPageRefreshStatus{
    case none
    case beginHeaderRefrsh
    case endHeaderRefresh
    case beginFooterRefresh
    case endFooterRefresh
    case NoMoreData
    case end
    // MARK 需要细化错误类型？
    case error(err:Error)
    
}



class mainPageViewMode {
    
   
    var compuseJobItems = PublishSubject<[CompuseRecruiteJobs]>.init()
    var banners =  PublishSubject<[RotateCategory]>.init()
    var combinationRecommands = PublishSubject<SpecialRecommands>.init()
    // 刷新状态
    let refreshStatus = PublishSubject<mainPageRefreshStatus>.init()
    // 是否刷新
    var refreshData = PublishSubject<Bool>.init()

    let demoServer:demoHttpServer = demoHttpServer.shared
    
    
    let disposebag = DisposeBag()
    
    // tableview 多个section 数据
    let sections: Driver<[MultiSecontions]>
    
    // 没有更多数据
    var moreData = true
    var index:Int = 0
    var allJobs:[CompuseRecruiteJobs] = []
    
    init() {
        
      
        // table section 数据组合
        // onError SpeicalRecommand 返回任意空值
        sections = Driver.combineLatest(self.combinationRecommands.asDriver(onErrorJustReturn: Mapper<SpecialRecommands>().map(JSON: ["null":0])!), self.compuseJobItems.asDriver(onErrorJustReturn: [])){ comb, jobs in
            
            (comb, jobs)
            }.map{ (args) -> [MultiSecontions] in
                let (comb, jobs) = args
                let articles = comb.news?.articles ?? []
                var alljobs:[SectionItem] = []
                jobs.forEach{
                    alljobs.append(SectionItem.campuseRecruite(job: $0))
                }
                
                return [MultiSecontions.newSection(title: "", items: [SectionItem.newItem(new: articles)]),
                        MultiSecontions.JobFieldSection(title: "", items: [SectionItem.jobFieldItem(comb.jobFields)]),
                        MultiSecontions.ColumnSection(title: "", items: [SectionItem.columnItem(comb.latestColumns)]),
                        MultiSecontions.RecruitMentMeet(title: "", items: [SectionItem.recruimentMeet(list: comb
                            .recruitMeetings)]),
                        MultiSecontions.ApplyOnline(title: "", items: [SectionItem.applyonline(list: comb.applyOnlineField)]),
                        MultiSecontions.CampuseRecruite(title: "", items: alljobs)
                        ]
            }
       
        
        
        // 下拉刷新 局部更新
        refreshData.subscribe(onNext: { [unowned self] IsPullDown  in
            
            self.index = IsPullDown ? 0 : self.index + 1
            if IsPullDown{
               
                // 获取banner 数据
                self.demoServer.getLastestCategory().subscribe(onNext: { (categories) in
                    self.banners.onNext(categories)
                }, onError: { (err) in
                    print("get category \(err)")
                    self.refreshStatus.onNext(.error(err: err))
                    self.banners.onError(err)
                    return
                }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposebag)
                
                // 组合数据
                self.demoServer.getMainRecommands().subscribe(onNext: { (recommands) in
                    self.combinationRecommands.onNext(recommands)
                    
                }, onError: { (err) in
                    print("get all recommand \(err)")
                    self.refreshStatus.onNext(.error(err: err))
                    self.combinationRecommands.onError(err)
                    return
                }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposebag)
                
                self.demoServer.getRecommandJobs(offset: self.index).subscribe(onNext: { (jobs) in
                    self.moreData = jobs.isEmpty ? false : true
                    self.allJobs = jobs
                    self.compuseJobItems.onNext(self.allJobs)
                }, onError: { (err) in
                    print("query recommnad jobs failed \(err)")
                    self.refreshStatus.onNext(.error(err: err))
                     self.compuseJobItems.onError(err)
                    return
                }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposebag)
            
                // 重置
                self.moreData = true
                // 获取数据正常 结束
                self.refreshStatus.onNext(.endHeaderRefresh)
                
            }
            else{
                self.demoServer.getRecommandJobs(offset: self.index).subscribe(onNext: { (jobs) in
                     self.moreData = jobs.isEmpty ? false : true
                     self.allJobs += jobs
                     self.compuseJobItems.onNext(self.allJobs)
                    
                }, onError: { (err) in
                    self.refreshStatus.onNext(.error(err: err))
                    self.compuseJobItems.onError(err)
                    return
                }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposebag)
                
                if self.moreData == false{
                    self.refreshStatus.onNext(.NoMoreData)
                }else{
                    self.refreshStatus.onNext(.endFooterRefresh)
                }
                
                
            }
            
            
        }).disposed(by: disposebag)
        
    }
    
}











