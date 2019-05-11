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
    private var pullDown:Bool = false
    
    internal let postItems:BehaviorRelay<[PostArticleModel]> = BehaviorRelay< [PostArticleModel]>.init(value: [])
    
    
    // 一级回复
    internal var articleReplyReq:PublishSubject<ArticleReplyReqModel> = PublishSubject<ArticleReplyReqModel>.init()
    internal var articleReplyRes:BehaviorRelay<[FirstReplyModel]> = BehaviorRelay<[FirstReplyModel]>.init(value: [])
    
    internal let refreshReplyStatus: PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    private var replyPullDown:Bool = false
    
    // 点赞 和 收藏
    //internal var like:PublishSubject<(String,Bool)> = PublishSubject<(String,Bool)>.init()
    //internal var collected: PublishSubject<(String,Bool)> = PublishSubject<(String,Bool)>.init()
    
    //internal var likeRes:PublishSubject<Bool> = PublishSubject<Bool>.init()
    //internal var collectedRes:PublishSubject<Bool> = PublishSubject<Bool>.init()
    
    
    private let dispose = DisposeBag.init()
    
    private let server: ForumeServer = ForumeServer.shared
    
    
    init() {
        self.sectionRequest.do(onNext: { [unowned self] (req) in
            self.pullDown = req.getOffset() == 0 ? true : false
        }).flatMapLatest { [unowned self] req in
            self.server.getPostItems(req: req).catchError({ err -> Observable<[PostArticleModel]> in
                // http 错误处理TODO
                return Observable<[PostArticleModel]>.just([])
            })}.debug().subscribe(onNext: { [weak self] (modes) in
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
        
        
        self.articleReplyReq.do(onNext: { [unowned self] (req) in
               self.replyPullDown = req.getOffset() == 0 ? true : false
        }).flatMapLatest {  [unowned self] req in
            self.server.articleReplys(req: req).asDriver(onErrorJustReturn: [])
            }.debug().subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else{
                    //self?.refreshReplyStatus.onNext(.error(err: NSError.init()))
                    return
                }
                    if res.isEmpty && self.replyPullDown == false{
                        self.refreshReplyStatus.onNext(.NoMoreData)
                        return
                    }
                    if self.replyPullDown{
                        self.articleReplyRes.accept(res)
                        self.refreshReplyStatus.onNext(PageRefreshStatus.endHeaderRefresh)
                    }else{
                        self.articleReplyRes.accept(self.articleReplyRes.value + res)
                        self.refreshReplyStatus.onNext(.endFooterRefresh)
                    }
                }, onError: { [weak self] err in
                    self?.refreshReplyStatus.onNext(.error(err: err))
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
//        self.like.flatMapLatest { [unowned self] (id,flag) in
//            self.server.likeArticle(postId: id, value: flag)
//            }.subscribe(onNext: { [weak self] (res) in
//
//                if let code = res.code,  HttpCodeRange.filterSuccessResponse(target: code){
//                    self?.likeRes.onNext(true)
//                }else{
//                    self?.likeRes.onNext(false)
//                }
//            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
//        self.collected.flatMapLatest {  [unowned self] (id, flag) in
//            self.server.collectedArticle(postId: id, value: flag)
//            }.subscribe(onNext: { [weak self] (res) in
//
//                if let code = res.code,  HttpCodeRange.filterSuccessResponse(target: code){
//                    self?.collectedRes.onNext(true)
//                }else{
//                    self?.collectedRes.onNext(false)
//                }
//
//            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
    }
    
//    internal func createArticle(title:String, content:String, type:String) -> Observable<HttpResultMode>{
//       return  server.createArtice(title: title, content: content, type: type)
//    }
    
    
    internal func likePost(postId:String, flag:Bool) ->  Observable<ResponseModel<HttpForumResponse>>{
        
        return self.server.likeArticle(postId: postId, value: flag)
    }
    
    internal func colletePost(postId:String, flag:Bool) -> Observable<ResponseModel<HttpForumResponse>>{
        return self.server.collectedArticle(postId: postId, value: flag)
    }
    
    internal func replyPost(postId:String, content:String) -> Observable<ResponseModel<HttpForumResponse>>{
        return self.server.userReplyPost(postId: postId, content: content)
    }
    
    internal func deletePostBy(postId:String) ->
        Observable<ResponseModel<HttpForumResponse>>{
        return self.server.deleteMyPostBy(postId: postId)
    }
    
    internal func addReadCount(postId:String){
        self.server.readCount(postId: postId)
    }
}
