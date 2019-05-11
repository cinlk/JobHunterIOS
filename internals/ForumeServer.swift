
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
    case collected(postId:String, flag:Bool)
    case replyPost(postId:String, content:String)
    case deletPost(postId:String)
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
        case .collected:
            return self.prefix + "/article/collect"
        case .replyPost:
            return self.prefix + "/article/reply"
        case .deletPost(let postId):
            return self.prefix + "/article/\(postId)"
        case .count(let postId):
            return self.prefix + "/article/count/\(postId)"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postItem(_), .createArticle:
            return .post
        case .like, .collected, .count:
            return .put
        case .replys, .replyPost:
            return .post
        case .deletPost:
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
}
