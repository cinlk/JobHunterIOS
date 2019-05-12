
//
//  forumeServer.swift
//  internals
//
//  Created by ke.liang on 2019/5/4.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import Moya
import RxCocoa
import RxSwift


internal enum forumTarget{
    case postItem(req: ArticleReqModel)
    case createArticle(title:String, content:String, type:String)
    case replys(req: ArticleReplyReqModel)
    case count(postId:String)
    case like(postId:String, flag:Bool)
    case likeReply(replyId:String, flag:Bool)
    case likeSubReply(subReplyId:String, flag:Bool)
    case collected(postId:String, flag:Bool)
    case replyPost(postId:String, content:String)
    case deletPost(postId:String)
    case deleteReply(replyId:String)
    case deleteSubReply(subReplyId:String)
    case subReplys(req:SubReplyReqModel)
    case newSubReply(replyId:String, talkedUserId:String, content:String)
    case alertPost(postId:String, content:String)
    case alertReply(replyId:String, content:String)
    case alertSubReply(subReplyId:String, content:String)
    case none
}

extension forumTarget: TargetType{
    
    var baseURL: URL {
        return URL.init(string: GlobalConfig.BASE_URL)!
    }
    var prefix:String{
        return "forum"
    }
    
    var path: String {
        switch  self {
        case .postItem(_):
            return self.prefix + "/articles"
        case .createArticle:
            return self.prefix + "/new/article"
        case .replys:
            return self.prefix + "/article/replys"
        case .like:
            return self.prefix + "/article/like"
        case .likeReply:
            return self.prefix + "/reply/like"
        case .likeSubReply:
            return self.prefix + "/subReply/like"
        case .collected:
            return self.prefix + "/article/collect"
        case .replyPost:
            return self.prefix + "/article/reply"
        case .deletPost(let postId):
            return self.prefix + "/article/\(postId)"
        case .deleteReply(let replyId):
            return self.prefix + "/reply/\(replyId)"
        case .deleteSubReply(let subReplyId):
            return self.prefix + "/subReply/\(subReplyId)"
        case .count(let postId):
            return self.prefix + "/article/count/\(postId)"
        case .subReplys:
            return self.prefix + "/subreply"
        case .newSubReply:
            return self.prefix + "/newSubreply"
        case .alertPost:
            return self.prefix + "/article/alert"
        case .alertReply:
            return self.prefix + "/reply/alert"
        case .alertSubReply:
            return self.prefix + "/subReply/alert"
            
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postItem(_), .createArticle, .newSubReply:
            return .post
        case .like, .collected, .count, .likeReply, .likeSubReply:
            return .put
        case .replys, .replyPost, .subReplys, .alertPost, .alertReply, .alertSubReply:
            return .post
        case .deletPost, .deleteReply, .deleteSubReply:
            return .delete
        default:
            return .get
        }
    }
    
    
    var sampleData: Data {
        return "".utf8Encoded
    }
    
    var task: Task {
        switch self {
        case .postItem(let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .createArticle(let title, let content, let type):
            return .requestParameters(parameters: ["title": title, "content": content, "type": type], encoding: JSONEncoding.default)
        case .like(let postId, let flag), .collected(let postId, let flag):
            return .requestParameters(parameters: ["post_id": postId, "flag": flag], encoding: JSONEncoding.default)
        case .replys(let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .replyPost(let postId, let content):
            return .requestParameters(parameters: ["post_id": postId, "reply_content": content], encoding: JSONEncoding.default)
        case .subReplys(let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case .likeReply(let replyId, let flag):
            return .requestParameters(parameters: ["reply_id": replyId, "flag": flag], encoding: JSONEncoding.default)
        case .likeSubReply(let subReplyId, let flag):
            return .requestParameters(parameters: ["sub_reply_id": subReplyId, "flag": flag], encoding: JSONEncoding.default)
            
        case .newSubReply(let replyId, let talkedUserId, let content):
            return .requestParameters(parameters: ["reply_id": replyId, "talked_user_id": talkedUserId, "content": content], encoding: JSONEncoding.default)
        case .alertPost(let postId, let content):
            return .requestParameters(parameters: ["post_id": postId, "content": content], encoding: JSONEncoding.default)
        case .alertReply(let replyId, let content):
            return .requestParameters(parameters: ["reply_id": replyId, "content": content], encoding: JSONEncoding.default)
        case .alertSubReply(let subReplyId, let content):
            return .requestParameters(parameters: ["sub_reply_id": subReplyId, "content": content], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return  ["Content-Type": "application/json", "Authorization": GlobalUserInfo.shared.getToken()]
    }
    
    
}


class ForumeServer{
    
    static let shared: ForumeServer = ForumeServer.init()
    
    private lazy var httpServer: MoyaProvider<forumTarget> = {
        let s = MoyaProvider<forumTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])
        return s
    }()
    
    private init() {}
    
    
    internal func getPostItems(req: ArticleReqModel) ->  Observable<[PostArticleModel]> {
        
        return httpServer.rx.request(.postItem(req: req)).retry(3).timeout(30, scheduler:
            ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapArray(PostArticleModel.self, tag: "body")
    }
    
    
    internal func createArtice(title:String, content:String, type:String) -> Observable<ResponseModel<HttpForumResponse>>{
        
        return httpServer.rx.request(.createArticle(title: title, content: content, type: type)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpForumResponse>.self)
    }
    
    
    internal func articleReplys(req: ArticleReplyReqModel) -> Observable<[FirstReplyModel]> {
        
        return httpServer.rx.request(.replys(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapArray(FirstReplyModel.self, tag: "body")//.mapObject(ResponseArrayModel<FirstReplyModel>.self)
        
        
    }
    
    internal func readCount(postId:String){
        self.httpServer.request(.count(postId: postId)) { result in
            print(result)
        }
    }
    
    internal func likeArticle(postId:String, value:Bool) ->  Observable<ResponseModel<HttpForumResponse>> {
        
      
        return httpServer.rx.request(.like(postId: postId, flag: value)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpForumResponse>.self)
    }
    
    internal func collectedArticle(postId:String, value:Bool) -> Observable<ResponseModel<HttpForumResponse>>{
        return httpServer.rx.request(.collected(postId: postId, flag: value)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpForumResponse>.self)
    }
    
    // 回复帖子
    internal func userReplyPost(postId:String, content:String) -> Observable<ResponseModel<HttpForumResponse>>{
        
        return httpServer.rx.request(.replyPost(postId: postId, content: content)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpForumResponse>.self)
    }
    
    // 删除帖子
    internal func deleteMyPostBy(postId:String) -> Observable<ResponseModel<HttpForumResponse>>{
        
        return httpServer.rx.request(.deletPost(postId: postId)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpForumResponse>.self)
    }
    
    // 删除回复
    internal func deleteReply(replyId:String) -> Observable<ResponseModel<HttpForumResponse>>{
        return httpServer.rx.request(.deleteReply(replyId: replyId)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpForumResponse>.self)
    }
    
    // 删除子回复
    internal func deleteSubReply(subReplyId:String) ->
        Observable<ResponseModel<HttpForumResponse>>{
            return httpServer.rx.request(.deleteSubReply(subReplyId: subReplyId)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpForumResponse>.self)
    }
    // 子回复
    
    internal func subReplys(req: SubReplyReqModel) -> Observable<[SecondReplyModel]>{
        return httpServer.rx.request(.subReplys(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapArray(SecondReplyModel.self, tag: "body")
    }
    
    // 点赞子回复
    internal func likeReply(replyId:String, flag:Bool) -> Observable<ResponseModel<HttpForumResponse>>{
        
        return httpServer.rx.request(.likeReply(replyId: replyId, flag: flag)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpForumResponse>.self)
    }
    
    // 发布子回复
    internal func newSubReply(replyId:String, talkedUserId:String, content:String) -> Observable<ResponseModel<HttpForumResponse>>{
        
        return httpServer.rx.request(.newSubReply(replyId: replyId, talkedUserId: talkedUserId, content: content)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpForumResponse>.self)
    }
    
    // 举报帖子
    internal func alertPost(postId:String, content:String) -> Observable<ResponseModel<HttpForumResponse>>{
        
        return httpServer.rx.request(.alertPost(postId: postId, content: content)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpForumResponse>.self)
    }
    
    // 举报子回复
    internal func alertReply(replyId:String, content:String) -> Observable<ResponseModel<HttpForumResponse>>{
        return httpServer.rx.request(.alertReply(replyId: replyId, content: content)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpForumResponse>.self)
    }
    // 举报二级回复
    internal func alertSubReply(subReplyId:String, content:String) -> Observable<ResponseModel<HttpForumResponse>>{
        return httpServer.rx.request(.alertSubReply(subReplyId: subReplyId, content: content)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpForumResponse>.self)
    }
    
    // 点赞子回复
    internal func likeSubReply(subReplyId:String, flag:Bool) ->
        Observable<ResponseModel<HttpForumResponse>>{
        
            return httpServer.rx.request(.likeSubReply(subReplyId: subReplyId, flag: flag)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpForumResponse>.self)
    }
}
