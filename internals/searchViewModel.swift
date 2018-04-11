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



struct filterCondtionss {
    var companyType:[String:[String]]?
    var position:[String:[String]]?
    var jobArea:[String:String]?
    
    var index = 0
    
    init() {
    
    }
    
    
}





class searchViewModel: NSObject {

    // 刷新数据
    var refresh:Variable<filterCondtionss> = Variable.init(filterCondtionss.init())
    // 搜索框 加载数据
    var loadData:PublishSubject<String> = PublishSubject<String>.init()
    
    var companyType:Variable<[String:[String]]> = Variable.init(["":[]])
    var position:Variable<[String:[String]]> = Variable.init(["":[]])
    var jobArea:Variable<[String:String]> = Variable.init(["":""])
    var index = 0
    let refreshStatus = Variable<mainPageRefreshStatus>.init(.none)
    // job model data
    let sectionJobData = Variable<[CompuseRecruiteJobs]>([])
    // table section
    var section:Driver<[searchJobSection]>?

    // 转换为 json 对象
    var combinCondtions:Observable<filterCondtionss>?
    
    var isRefresh:PublishSubject<Bool> = PublishSubject.init()
    
    let disposeBag = DisposeBag.init()
    
    var noMoredata = false
    
    // test
    var test = 1
    override init(){
        super.init()
        
            
        section = sectionJobData.asObservable().map{ (jobs) -> [searchJobSection] in
            return [searchJobSection.init(items: jobs)]
        }.asDriver(onErrorJustReturn: [])
        
        
        combinCondtions = Observable.combineLatest(companyType.asObservable(), position.asObservable(), jobArea.asObservable(), resultSelector: { (comp, position, area) in
            var filter = filterCondtionss.init()
            filter.companyType = comp
            filter.jobArea = area
            filter.position = position
            return filter
        
        }).asObservable().share(replay:1)
        
        
        loadData.subscribe(onNext: { (word) in
            // 搜索的word
            mainPageServer.shareInstance.searchKeyByWord(word: word).subscribe(onNext: { [unowned self] (jobs) in
                self.sectionJobData.value = jobs
                
                }, onError: { (error) in
                    self.sectionJobData.value = []
                    self.refreshStatus.value = .error
            }, onCompleted: {
                //self.refreshStatus.value = .endFooterRefresh
                self.refreshStatus.value = .end
                
            }, onDisposed: nil).disposed(by: self.disposeBag)
            
        }).disposed(by: disposeBag)
        
        
        
        isRefresh.subscribe(onNext: { [unowned self] (more) in
            self.index = more ? self.index + 1 : 0
            
            // MARK  change to post method
            
            mainPageServer.shareInstance.searchKeyByWord(word: String(self.test)).subscribe(onNext: { [unowned self] (jobbs) in
                
                self.sectionJobData.value = more ? self.sectionJobData.value + jobbs : jobbs
                if jobbs.isEmpty{
                    self.noMoredata = true
                }
                self.test += 1
                
            }, onError: nil, onCompleted: {
                self.refreshStatus.value =  self.noMoredata ? .NoMoreData : .endFooterRefresh
            }, onDisposed: nil).disposed(by: self.disposeBag)
            }, onDisposed: nil).disposed(by: disposeBag)
       
        
    }
    
    
    
    
    
    
    
    
}
