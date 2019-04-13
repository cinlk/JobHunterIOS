//
//  SpecialJobsViewModel.swift
//  internals
//
//  Created by ke.liang on 2019/2/12.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation


import RxCocoa
import RxSwift

class SpecailJobViewModel {
    
    
    private var dispose: DisposeBag = DisposeBag()
    private let httpServer: DemoHttpServer = DemoHttpServer.shared
    
    let data:BehaviorRelay = BehaviorRelay<[JobListModel]>.init(value: [])
    let refresh:BehaviorRelay<Bool> = BehaviorRelay<Bool>.init(value: false)
    let refreshState:BehaviorSubject<PageRefreshStatus> = BehaviorSubject<PageRefreshStatus>.init(value: .none)
    
    private var offset:Int = 0
    private var limit:Int = 10
    private var kind:String = ""
    
    init(kind:String, limit:Int = 10) {
        self.kind = kind
        self.limit = limit
        
        refresh.share().do(onNext:{ [unowned self] b in
            
                self.offset = b ? 0 : self.offset + 1
        }).flatMapLatest{ [unowned self] (b)  in
                return self.httpServer.getJobsBy(kind: self.kind, offset: self.offset, limit: self.limit)
                
            }.subscribe(onNext: { [unowned self]  (model) in
                if let code = model.code, HttpCodeRange.filterSuccessResponse(target: code) {
                    let res = model.body ?? []
                    if self.refresh.value == true{
                        self.data.accept(res)
                        self.refreshState.onNext(PageRefreshStatus.endHeaderRefresh)
                        return
                    }else{
                        if res.isEmpty{
                            self.refreshState.onNext(PageRefreshStatus.NoMoreData)
                            return
                        }
                        // 成功
                        self.data.accept(self.data.value + res)
                        self.refreshState.onNext(PageRefreshStatus.endFooterRefresh)
                        
                    }
                    
                }else{
                    // 错误
                    self.refreshState.onNext(PageRefreshStatus.error(err: NSError.init(domain: "", code: -1, userInfo: model.toJSON())))
                }
                
            }).disposed(by: self.dispose)
        
        
        
        
    }
}
