//
//  forumViewModel.swift
//  internals
//
//  Created by ke.liang on 2018/6/26.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa




class ForumViewModel{
    
    // 获取热门的帖子
    //internal let popularContent:PublishSubject<String> = PublishSubject<String>.init()
    
    internal let sectionRequest:PublishSubject<ArticleReqModel> = PublishSubject<ArticleReqModel>.init()
    internal let refreshStatus: PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    internal var pullDown:Bool = false
    
    internal let postItems:BehaviorRelay<[PostArticleModel]> = BehaviorRelay< [PostArticleModel]>.init(value: [])
    
    private let dispose = DisposeBag.init()
    
    private let server: ForumeServer = ForumeServer.shared
    
    init() {
        self.sectionRequest.do(onNext: { [unowned self] (req) in
            self.pullDown = req.getOffset() == 0 ? true : false
        }).flatMapLatest { [unowned self] req in
            self.server.getPostItems(req: req).asDriver(onErrorJustReturn: [])
            }.subscribe(onNext: { [weak self] (modes) in
                guard let `self` = self else {
                    return
                }
                if modes.isEmpty && self.pullDown == false{
                    self.refreshStatus.onNext(.NoMoreData)
                    return
                }
                if self.pullDown{
                    self.postItems.accept(modes)
                    self.refreshStatus.onNext(PageRefreshStatus.endHeaderRefresh)
                }else{
                    self.postItems.accept(self.postItems.value + modes)
                    self.refreshStatus.onNext(.endFooterRefresh)
                }
                
            }, onError: { [weak self] err in
                self?.refreshStatus.onNext(.error(err: err))
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
    }
    
}
