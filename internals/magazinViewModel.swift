//
//  magazinViewModel.swift
//  internals
//
//  Created by ke.liang on 2019/2/9.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import ObjectMapper

class MagazineViewModel {
    
    
    let refresh:PublishSubject<Bool> = PublishSubject<Bool>.init()
    
    private let dispose = DisposeBag()
    let refreshState:BehaviorSubject<PageRefreshStatus> = BehaviorSubject<PageRefreshStatus>.init(value: .none)
    private var offset = 0
    
    let models: BehaviorRelay<[MagazineModel]> = BehaviorRelay<[MagazineModel]>.init(value: [])
    
    
    init() {
        
        
        
        self.refresh.subscribe(onNext: { pullDown in
            self.offset = pullDown ? 0 : self.offset + 1
            
            let tmp = self.models.value
            
            
            NetworkTool.request(.news(type: "test", offset: self.offset), successCallback: { (json) in
                
                guard let res = json as? [String: Any], let r = res["body"] as? [[String: Any]] else {
                    self.refreshState.onNext(.error(err: NSError.init(domain: "json decode failed", code: -9999, userInfo: nil)))
                    return
                }
                
                if pullDown{
                    self.models.accept(Mapper<MagazineModel>().mapArray(JSONArray: r))
                    self.refreshState.onNext(.endHeaderRefresh)
                }else{
                    let objs = Mapper<MagazineModel>().mapArray(JSONArray: r)
                    if objs.isEmpty{
                        self.refreshState.onNext(.NoMoreData)
                        return
                    }
                    self.models.accept(tmp + objs)
                    self.refreshState.onNext(.endFooterRefresh)
                }
                
                
                
            }, failureCallback: { (error) in
                self.refreshState.onNext(.error(err: error))
            })
            
            
        }).disposed(by: self.dispose)
        
        
    }
    
    
}
