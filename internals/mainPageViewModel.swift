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
    case error
    
}



class mainPageViewMode {
    
    // 校招job数据
    var compuseJobItems = Variable<[CompuseRecruiteJobs]>.init([])
    // 实习job数据
    var internJobItems = Variable<[InternshipJobs]>.init([])
    //MARK catagory数据
    var catagory = Variable<[String:String]>.init([:])
    
    //MARK recommand 数据
    var recommand = Variable<[String:String]>.init([:])
    
    // 刷新状态
    let refreshStatus = Variable<mainPageRefreshStatus>.init(.none)
    
    var refreshData = PublishSubject<Bool>.init()
    
    
    
    var index:Int = 0
    
    var request:mainPageServer!
    
    let disposebag = DisposeBag()
    
    // 没有更多数据
    var moreData = true
    // tableview 多个section 数据
    let sections: Driver<[MultiSecontions]>
    
    init(request: mainPageServer) {
        
        self.request = request

       
        
        
        // 转换为 multisection 数据，注意section顺序
        sections = Driver.combineLatest(compuseJobItems.asDriver(), recommand.asDriver(), catagory.asDriver()){
            compusejob, recommands,catagories in
            (compusejob,recommands,catagories)
            }.map{ (arg) -> [MultiSecontions] in
                
                let (compusejobs, recommands, cts) = arg
                var CampuseItems:[SectionItem] = []
                for i in compusejobs{
                    CampuseItems.append(SectionItem.campuseRecruite(job: i))
                }
                return [ MultiSecontions.CatagorySection(title: "", items: [SectionItem.catagoryItem(imageNames: cts)]),
                    MultiSecontions.RecommandSection(title: "", itmes: [SectionItem.recommandItem(imageNames: recommands)]),
                    MultiSecontions.CampuseRecruite(title: "校招", items: CampuseItems)]
            }
        
        
        
        // MARK  上拉刷新 全部刷新
        // 下拉刷新 局部更新
        refreshData.subscribe(onNext: { [unowned self] IsPullDown  in
            self.index = IsPullDown ? 0 : self.index + 1
            if IsPullDown{
               
                // 分 3次请求拉取数据，合并一次请求？？？
                // 得到所有数据才展示界面
                _ = self.request.getCatagories().subscribe(onNext: { (names) in
                    self.catagory.value = names
                })
                _ = self.request.getRecommand().subscribe(onNext: { (names) in
                    self.recommand.value = names
                }, onError: {
                    error in
                    print(error)
                    // 处理错误
                    self.refreshStatus.value = .error
                }
                )
                
                _ = self.request.getCompuseJobs(index: self.index).subscribe(onNext: { (compuseJobs) in
                    self.compuseJobItems.value = IsPullDown ? compuseJobs : (self.compuseJobItems.value) + compuseJobs
                }, onError: { error in
                    // 处理错误
                    //Thread.sleep(forTimeInterval: 2)
                    print(error)
                    self.compuseJobItems.value = []
                    self.refreshStatus.value = .error
                }, onCompleted: {
                    // 正常结束
                    self.moreData = true
                    self.refreshStatus.value = IsPullDown ? .endHeaderRefresh : .endFooterRefresh
                }, onDisposed: nil)
                
            // 上拉刷新
            }else{
                self.request.getCompuseJobs(index: self.index).debug().subscribe({  [unowned self] event  in
                    switch event{
                    case let .next(items):
                        if items.isEmpty{
                            self.moreData = false
                        }
                        self.compuseJobItems.value = IsPullDown ? items : (self.compuseJobItems.value) + items
                    
                    case .error(_):
                        self.compuseJobItems.value = []
                    case .completed:
                        if !self.moreData{
                            self.refreshStatus.value = .NoMoreData
                        }else{
                            self.refreshStatus.value = IsPullDown ? .endHeaderRefresh : .endFooterRefresh
                        }
                    }
                }).disposed(by: self.disposebag)
            }
            }, onError: { error in
                print(error)
                self.refreshStatus.value = .error
                
        }, onCompleted: {
            print("获取数据完成")
        }, onDisposed: nil).disposed(by: disposebag)
        
    }
    
    
    
}











