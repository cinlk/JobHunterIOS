//
//  messageViewModel.swift
//  internals
//
//  Created by ke.liang on 2019/4/27.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift




class MessageViewModel {
    
    
    static let shared: MessageViewModel = MessageViewModel.init()
    
    private var dispose: DisposeBag = DisposeBag.init()
    
    private var httpServer:MessageHttpServer = MessageHttpServer.shared
    
    internal var updateVisitorTime: BehaviorSubject<String> = BehaviorSubject<String>.init(value: "")
    
    // 获取结果 跟新UI
    internal var existNewVisitor:PublishSubject<Bool> = PublishSubject<Bool>.init()
    
    internal var refreshVisitor: PublishSubject<HttpVisitorReq> = PublishSubject<HttpVisitorReq>()
    // 访问者数据
    internal var visitors: BehaviorRelay<[MyVisitors]> = BehaviorRelay<[MyVisitors]>.init(value: [])
    
    
    // 从UI发送 获取结果数据
    internal var existVisitor: PublishSubject<String> = PublishSubject<String>.init()
    
    
    // 系统消息
    internal var existNewSystemMessage: PublishSubject<String> = PublishSubject<String>.init()
    internal var newSystemMessage:PublishSubject<Bool> = PublishSubject<Bool>.init()
    internal var updateNewSystemMessageTime:PublishSubject<String> = PublishSubject<String>.init()
    
    
    // 点赞消息
    internal var existThumbUpMessage: PublishSubject<String> = PublishSubject<String>.init()
    internal var newThumbUpMessage: PublishSubject<Bool> = PublishSubject<Bool>.init()
    internal var updateThumbUpMessageTime:PublishSubject<String> = PublishSubject<String>.init()
    
    
    
    // 回复我的帖子消息
    internal var existReply2Me: PublishSubject<String> = PublishSubject<String>.init()
    internal var newReply2MeMessage: PublishSubject<Bool> = PublishSubject<Bool>.init()
    internal var updateReply2MeTime: PublishSubject<String> = PublishSubject<String>.init()
    
    
    
    internal var updateVisitor: BehaviorRelay<(String, String)> = BehaviorRelay<(String, String)>.init(value: ("", ""))
    
    
    // 刷新状态
    internal let visitorRefreshStatus:PublishSubject<PageRefreshStatus> = PublishSubject<PageRefreshStatus>.init()
    internal var visitorPullDown = false
    
    
    init() {
        
        self.updateVisitorTime.subscribe(onNext: { [weak self] id in
            self?.httpServer.checkVisitorTime(userId: id)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        self.existVisitor.flatMapLatest { [unowned self] (id)  in
            self.httpServer.hasNewVisitor(userId: id)
        }.subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                     self?.existNewVisitor.onNext(res.body?.exist ?? false)
                    
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        
        self.updateVisitor.subscribe(onNext: { [weak self] (rid, uid) in
            self?.httpServer.updateVisitor(recruiterId: rid, userId: uid)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        self.existNewSystemMessage.flatMapLatest { [unowned self] (uid) in
            self.httpServer.hasNewSystemMessage(userId: uid)
            }.subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    self?.newSystemMessage.onNext(res.body?.exist ?? false)
                }
                
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.updateNewSystemMessageTime.subscribe(onNext: { [weak self] (uid) in
            self?.httpServer.systemMessageTime(userId: uid)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        // 点赞
        self.existThumbUpMessage.flatMapLatest {  [unowned self] uid in
            self.httpServer.HasNewThumbUpMessage(userId: uid)
            }.subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    self?.newThumbUpMessage.onNext(res.body?.exist ?? false)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
    
        self.updateThumbUpMessageTime.subscribe(onNext: { [weak self] (uid) in
            self?.httpServer.thumbUpMessageTime(userId: uid)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        // 回复我的
        self.existReply2Me.flatMapLatest { [unowned self]  uid  in
            self.httpServer.HasNewForumReply2Me(userId: uid)
            }.subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    self?.newReply2MeMessage.onNext(res.body?.exist ?? false)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.updateReply2MeTime.subscribe(onNext: { [weak self] (uid) in
            self?.httpServer.forumReplyTime(userId: uid)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        self.refreshVisitor.do(onNext: { [unowned self] (req) in
            self.visitorPullDown =  req.offset == 0 ? true : false
        }).flatMapLatest { [unowned self] (req) in
            self.httpServer.visitors(req: req).asDriver(onErrorJustReturn: [])
            }.subscribe(onNext: { [weak self] (modes) in
                guard let `self` = self else{
                    return
                }
                if modes.isEmpty && self.visitorPullDown == false {
                    self.visitorRefreshStatus.onNext(PageRefreshStatus.NoMoreData)
                    return
                }
                if self.visitorPullDown{
                    self.visitors.accept(modes)
                    self.visitorRefreshStatus.onNext(.endHeaderRefresh)
                }else{
                    self.visitors.accept(self.visitors.value + modes)
                    self.visitorRefreshStatus.onNext(.endFooterRefresh)
                }
                
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
    }
    
}
