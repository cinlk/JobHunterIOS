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



class SearchViewModel {
    
    //网申
   
    var onlineApplyRes:PublishSubject<[OnlineApplyListModel]> = PublishSubject<[OnlineApplyListModel]>.init()
    
    //校招
  
    var graduateRes:PublishSubject<[JobListModel]> = PublishSubject<[JobListModel]>.init()
    
    
    //实习
  
    var internRes:PublishSubject<[JobListModel]> = PublishSubject<[JobListModel]>.init()
    
    // 宣讲会
 
    var carrerTalkRes:PublishSubject<[CareerTalkMeetingListModel]> = PublishSubject<[CareerTalkMeetingListModel]>.init()

    
    // 公司
 
    var companyRes:PublishSubject<[CompanyListModel]> = PublishSubject<[CompanyListModel]>.init()
    
    
    
    let disposeBag = DisposeBag.init()
    let searchServer = SearchServer.shared
   

    
    init(){}
    
    
    
    // onlineSearch
    
    // 搜索不同板块的 热门搜索记录
    func searchLatestHotRecord(type:String) -> Observable<ResponseArrayModel<TopWord>>{
        
        return searchServer.getTopWords(type: type).throttle(0.5, scheduler: MainScheduler.instance).observeOn(MainScheduler.instance).share()
        
    }
    
    func searchMatchWords(type:String, word:String) -> Observable<ResponseModel<MatchKeyWordsModel>>{
        
        return searchServer.getMatchedWords(type: type, word: word)
    }
    
    
    // 搜索不同类型 根据关键字查数据
    func searchOnlineAppy(word:String){
    
        
        searchServer.searchOnlineAppy(word: word).asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] (modes) in
            self?.onlineApplyRes.onNext(modes)
        }).disposed(by: self.disposeBag)
    }
    
    
    func searchGraduteJobs(word: String){
        
        searchServer.searchGraduateJobs(word:word).asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] (modes) in
            self?.graduateRes.onNext(modes)
        }).disposed(by: self.disposeBag)
        
    }
    
    
    func searchInternJobs(word: String){
        
        searchServer.searchInternJobs(word: word).asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] (modes) in
            self?.internRes.onNext(modes)
        }).disposed(by: self.disposeBag)
        
    }
    
    
    func searchCareerTalkMeetins(word: String){
        
        searchServer.searchCareerTalkMeetins(word: word).asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] (modes) in
            self?.carrerTalkRes.onNext(modes)
        }).disposed(by: self.disposeBag)
    }
    
    
    func searchCompany(word:String){
        
        searchServer.searchCompany(word: word).asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] (modes) in
            self?.companyRes.onNext(modes)
        }).disposed(by: self.disposeBag)
    }
    
    
    
}



