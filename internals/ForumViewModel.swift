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
    
    // 二级回复
    
    internal var subReplyReq: PublishSubject<SubReplyReqModel> = PublishSubject<SubReplyReqModel>.init()
    internal var subReplyRes: BehaviorRelay<[SecondReplyModel]> = BehaviorRelay<[SecondReplyModel]>.init(value: [])
    internal let refreshSubReplyStatus: PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    private var subReplyPullDown:Bool = false
    
    // 搜索 test
    internal let postSearch:PublishSubject<ForumSearchReq> = PublishSubject<ForumSearchReq>.init()
    private var newSearch:Bool = false
    internal let searchRes:BehaviorRelay<[PostArticleModel]> = BehaviorRelay<[PostArticleModel]>.init(value: [])
    internal let searchRefresh:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    
    
    
    
    private let dispose = DisposeBag.init()
    
    private let server: ForumeServer = ForumeServer.shared
    
    internal  let searching: Driver<Bool>
    private let  activityIndicator = ActivityIndicator()

    
    init() {
        
        self.searching = activityIndicator.asDriver()
        
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
        
        
        self.subReplyReq.do(onNext: { [unowned self] (req) in
            self.subReplyPullDown = req.getOffset() == 0 ? true : false
        }).flatMapLatest {  [unowned self] req in
            self.server.subReplys(req: req).asDriver(onErrorJustReturn: [])
            }.debug().subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else {
                    return
                }
                if res.isEmpty && self.subReplyPullDown == false {
                    self.refreshSubReplyStatus.onNext(.NoMoreData)
                    return
                }
                if self.subReplyPullDown{
                    self.subReplyRes.accept(res)
                    self.refreshSubReplyStatus.onNext(.endHeaderRefresh)
                }else{
                    self.subReplyRes.accept(self.subReplyRes.value + res)
                    self.refreshSubReplyStatus.onNext(.endFooterRefresh)
                }
                
                
            }, onError: { [weak self] err in
                self?.refreshSubReplyStatus.onNext(.error(err: err))
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        // 搜索
        self.postSearch.do(onNext: { [unowned self] (req) in
            self.newSearch =  req.offset == 0 ?  true : false
        }).flatMapLatest { [unowned self] req in
            self.server.searchPost(req: req).trackActivity(self.activityIndicator).asDriver(onErrorJustReturn: [])
            }.debug().subscribe(onNext: { [weak self] (res) in
                
            if self?.newSearch ?? false  {
                 self?.searchRes.accept(res)
                
            }else{
                if res.isEmpty{
                    self?.searchRefresh.onNext(.NoMoreData)
                }else{
                    self?.searchRes.accept((self?.searchRes.value ?? []) + res)
                    self?.searchRefresh.onNext(.endFooterRefresh)
                }
        
            //self?.searchRes.accept((self?.searchRes.value ?? []) + body.words)
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
    }
    
    
    
    
    internal func likePost(postId:String, flag:Bool) ->  Observable<ResponseModel<HttpForumResponse>>{
        
        return self.server.likeArticle(postId: postId, value: flag)
    }
    
    internal func likeReply(replyId:String, flag:Bool) -> Observable<ResponseModel<HttpForumResponse>>{
        return self.server.likeReply(replyId: replyId, flag: flag)
    }
    
    internal func likeSubReply(subReplyId:String, flag:Bool) -> Observable<ResponseModel<HttpForumResponse>>{
        return self.server.likeSubReply(subReplyId: subReplyId, flag: flag)
    }
    
    internal func colletePost(postId:String, flag:Bool) -> Observable<ResponseModel<HttpForumResponse>>{
        return self.server.collectedArticle(postId: postId, value: flag)
    }
    
    internal func replyPost(postId:String, content:String) -> Observable<ResponseModel<HttpForumResponse>>{
        return self.server.userReplyPost(postId: postId, content: content)
    }
    
    internal func postSubReply(replyId:String, talkedUserId:String, content:String) -> Observable<ResponseModel<HttpForumResponse>>{
        return self.server.newSubReply(replyId: replyId, talkedUserId: talkedUserId, content: content)
    }
    
    internal func deletePostBy(postId:String) ->
        Observable<ResponseModel<HttpForumResponse>>{
        return self.server.deleteMyPostBy(postId: postId)
    }
    
    internal func deleteReply(replyId:String) -> Observable<ResponseModel<HttpForumResponse>>{
        return self.server.deleteReply(replyId: replyId)
    }
    
    internal func deleteSubReply(subReplyId:String) ->
        Observable<ResponseModel<HttpForumResponse>> {
        return self.server.deleteSubReply(subReplyId: subReplyId)
    }
    
    
    internal func addReadCount(postId:String){
        self.server.readCount(postId: postId)
    }
    
    // 举报帖子
    internal func alertPost(postId:String, content:String) -> Observable<ResponseModel<HttpForumResponse>>{
        return self.server.alertPost(postId: postId, content: content)
    }
    
    internal func alertReply(replyId:String, content:String) -> Observable<ResponseModel<HttpForumResponse>>{
        return self.server.alertReply(replyId: replyId, content: content)
    }
    internal func alertSubReply(subReplyId:String, content:String) -> Observable<ResponseModel<HttpForumResponse>>{
        return self.server.alertSubReply(subReplyId: subReplyId, content: content)
    }
    
    
    
    // 更新帖子分组
    internal func newPostGroup(postId:String, name:[String]) -> Observable<ResponseModel<HttpResultMode>>{
        return self.server.newPostGroup(postId: postId, name: name)
    }
    
    // 获取帖子的分组
    
    internal func postGroup(postId:String) -> Observable<ResponseModel<PostRelateGroup>>{
        return self.server.postGroup(postId: postId)
    }
    
    internal func getOnePost(postId:String) -> Observable<ResponseModel<PostArticleModel>>{
        return self.server.getOnePost(postId: postId)
    }
    
        
   
}
