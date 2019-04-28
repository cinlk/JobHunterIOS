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


class MainPageViewMode {
    
    private let compuseJobItems = PublishSubject<[JobListModel]>.init()
    let banners =  PublishSubject<[RotateCategory]>.init()
    private let combinationRecommands = PublishSubject<SpecialRecommands>.init()
    // 刷新状态
    let refreshStatus = PublishSubject<PageRefreshStatus>.init()
    // 是否刷新
    let refreshData = PublishSubject<Bool>.init()

    private let demoServer:DemoHttpServer = DemoHttpServer.shared
    
    
    private let disposebag = DisposeBag()
    
    // tableview 多个section 数据
    let sections: Driver<[MultiSecontions]>
    
    
    // 没有更多数据
    var moreData = true
    var index:Int = 0
    
    private  var allJobs:[JobListModel] = []
    
    init() {
        // table section 数据组合
        // onError SpeicalRecommand 返回任意空值
        
        sections = Driver.combineLatest(self.combinationRecommands.asDriver(onErrorJustReturn: Mapper<SpecialRecommands>().map(JSON: [:])!), self.compuseJobItems.asDriver(onErrorJustReturn: [])){ comb, jobs in
            
            (comb, jobs)
            }.map{ (args) -> [MultiSecontions] in
                let (comb, jobs) = args
                
               
                let articles =  comb.news.map({ (n) -> String in
                    return n.articles ?? ""
                })
                var alljobs:[SectionItem] = []
                jobs.forEach{
                    alljobs.append(SectionItem.campuseRecruite(job: $0))
                }
                
                return [MultiSecontions.newSection(title: "", items: [SectionItem.newItem(new: articles)]),
                        MultiSecontions.jobFieldSection(title: "", items: [SectionItem.jobFieldItem(comb.jobFields)]),
                        MultiSecontions.columnSection(title: "", items: [SectionItem.columnItem(comb.latestColumns)]),
                        MultiSecontions.recruitMentMeet(title: "", items: [SectionItem.recruimentMeet(list: comb
                            .recruitMeetings)]),
                        MultiSecontions.applyOnline(title: "", items: [SectionItem.applyonline(list: comb.applyOnlineField)]),
                        MultiSecontions.campuseRecruite(title: "", items: alljobs)
                        ]
            }
        
       
        
        
        // 下拉刷新 局部更新
        refreshData.subscribe(onNext: { [unowned self] IsPullDown  in
            
            self.index = IsPullDown ? 0 : self.index + 1
            
            if IsPullDown{
                // 并发获取 结果
            
                
                Observable.zip(self.demoServer.getLastestCategory(),
                               self.demoServer.getMainRecommands(),
                               self.demoServer.getRecommandJobs(offset: self.index, limit: 10)).subscribe(onNext: { [weak self] (categories, recommands, jobs) in
                                
                                print("get recommands \(recommands)")
                                self?.banners.onNext(categories)
                                self?.combinationRecommands.onNext(recommands)
                                self?.moreData = jobs.isEmpty ? false : true
                                self?.allJobs = jobs
                                self?.compuseJobItems.onNext(self?.allJobs ?? [])
                                self?.refreshStatus.onNext(.endHeaderRefresh)
                                
                                
                               }, onError:{ [weak self] (error) in
                                
                                self?.refreshStatus.onNext(.error(err: error))
                                self?.banners.onError(error)
                                self?.combinationRecommands.onError(error)
                                self?.compuseJobItems.onError(error)
                                
                               }).disposed(by: self.disposebag)
                
                self.moreData = true
              
            }
            else{
                
                self.demoServer.getRecommandJobs(offset: self.index, limit: 10).subscribe(onNext: { [weak self] (jobs) in
                     self?.moreData = jobs.isEmpty ? false : true
                     self?.allJobs += jobs
                     self?.compuseJobItems.onNext(self?.allJobs ?? [])
                    
                }, onError: {  [weak self] (err) in
                    self?.refreshStatus.onNext(.error(err: err))
                    self?.compuseJobItems.onError(err)
                    return
                }).disposed(by: self.disposebag)
                
                if self.moreData == false{
                    self.refreshStatus.onNext(.NoMoreData)
                }else{
                    self.refreshStatus.onNext(.endFooterRefresh)
                }
            }
        }).disposed(by: disposebag)
        
    }
    
    deinit {
        print("deinit mainpageViewModel \(String.init(describing: self))")
    }
}











