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
    
    //MARK catagory数据
    var catagory = Variable<[String:String]>.init([:])
    
    //MARK recommand 数据
    var recommand = Variable<[String:String]>.init([:])
    
    // 宣讲会
    var recruitMentMeets = Variable<[CareerTalkMeetingModel]>.init([])
    // 网申
    var applys = Variable<[applyOnlineModel]>.init([])
    
    // 刷新状态
    let refreshStatus = Variable<mainPageRefreshStatus>.init(.none)
    
    var refreshData = PublishSubject<Bool>.init()
    
    
    
    var index:Int = 0
    
    var request:mainPageServer!
    
    let disposebag = DisposeBag()
    
    var banners =  Variable<[RotateImages]>.init([])
    let driveBanner: Driver<[RotateImages]>
    // 没有更多数据
    var moreData = true
    // tableview 多个section 数据
    let sections: Driver<[MultiSecontions]>
    
    init(request: mainPageServer) {
        
        self.request = request

       
        
        driveBanner = banners.asDriver()
        
        
        
        // 转换为 multisection 数据，注意section顺序
        sections = Driver.combineLatest(recommand.asDriver(), catagory.asDriver(), recruitMentMeets.asDriver(),applys.asDriver(), compuseJobItems.asDriver()){
            
            recommands,catagories, meeting, applys, jobs in
            (recommands,catagories, meeting, applys, jobs)
            }.map{ (arg) -> [MultiSecontions] in
                
                let (recommands, cts, meets, applys, jobs) = arg
                var recommandjobs:[SectionItem] = []
                jobs.forEach{
                    recommandjobs.append(SectionItem.campuseRecruite(job: $0))
                }
                
                
                // 手动添加news！！！
                return [MultiSecontions.newSection(title: "", items: [SectionItem.newItem(new: ["语句1","语句2","语句3","语句4"])]),
                        MultiSecontions.CatagorySection(title: "", items: [SectionItem.catagoryItem(imageNames: cts)]),
                        MultiSecontions.RecommandSection(title: "", itmes: [SectionItem.recommandItem(imageNames: recommands)]),
                        MultiSecontions.RecruitMentMeet(title: "", items: [SectionItem.recruimentMeet(list: meets)]),
                        MultiSecontions.ApplyOnline(title: "", items: [SectionItem.applyonline(list: applys)]),
                        MultiSecontions.CampuseRecruite(title: "", items: recommandjobs)
                    ]
            }
        
        
        
      
        // MARK  上拉刷新 全部刷新
        // 下拉刷新 局部更新
        refreshData.subscribe(onNext: { [unowned self] IsPullDown  in
            
            self.index = IsPullDown ? 0 : self.index + 1
            if IsPullDown{
               
                // 获取banner 数据
            
                _ =  self.request.getImageBanners().subscribe(onNext: { rotates in
                    self.banners.value = rotates
                    
                }, onError: { (error) in
                    self.refreshStatus.value = .error
                    return
                })
                // 获取 
                
                // 获取第第一栏 数据
                _ = self.request.getCatagories().subscribe(onNext: { (names) in
                    self.catagory.value = names
                }, onError: { error in
                    self.refreshStatus.value = .error
                    return
                })
                // 获取 专栏数据（论坛贴，面试经验总结，习题集推荐等）
                _ = self.request.getRecommand().subscribe(onNext: { (names) in
                    self.recommand.value = names
                }, onError: { error in 
                    self.refreshStatus.value = .error
                    return
                })
                // 获取推荐职位
                _ = self.request.getCompuseJobs(index: 0).subscribe(onNext: { (jobs) in
                    self.compuseJobItems.value = jobs
                    
                }, onError: { (error) in
                    self.refreshStatus.value = .error
                    return
                })
                
                // 获取热门宣讲会
                _  = self.request.getHotRecruitMeetings().subscribe(onNext: { (hotMeeting) in
                    self.recruitMentMeets.value = hotMeeting
                    
                }, onError: { (error) in
                    self.refreshStatus.value = .error
                    return
                })
                // 获取热门网申
                _ = self.request.getHotApplyOnlines().subscribe(onNext: { (applys) in
                    self.applys.value = applys
                }, onError: { (error) in
                    self.refreshStatus.value = .error
                    return
                }, onCompleted: nil, onDisposed: nil)
                
                // 重置
                self.moreData = true
                // 获取数据正常 结束
                self.refreshStatus.value = .endHeaderRefresh
            }
            else{
                _ = self.request.getCompuseJobs(index: self.index).subscribe(onNext: { (jobs) in
                    if jobs.isEmpty{
                        self.moreData = false
                    }
                    self.compuseJobItems.value  = IsPullDown ? jobs : (self.compuseJobItems.value) + jobs
                    
                    
                }, onError: { (error) in
                    self.refreshStatus.value = .error
                    return
                    
                }, onCompleted: {
                    if !self.moreData{
                        self.refreshStatus.value = .NoMoreData
                    }else{
                        self.refreshStatus.value =  IsPullDown ? .endHeaderRefresh : .endFooterRefresh
                    }
                    
                }, onDisposed: nil)
            }
            
            
        }).disposed(by: disposebag)
        
    }
    
}











