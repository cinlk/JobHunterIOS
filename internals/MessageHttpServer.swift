//
//  messageHttpServer.swift
//  internals
//
//  Created by ke.liang on 2019/3/11.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import ObjectMapper



enum MessegeHttpReq{
    
    case getNewMessage(userID:String)
    case recruiterInfo(userId:String)
    // 创建新的会话
    case newConversation(cid:String,  recruiterId:String, jobId:String)
    
    // 访问者
    case myVisitors(req: HttpVisitorReq)
    case checkVisitor(userId:String, recruiterId:String)
    case visitorTime(userId:String)
    case newVisitor(userId:String)
    
    // 检查最新系统消息
    case newSystemMessage(userId:String)
    case systemMessageTime(userId:String)
    
    // 检查点赞消息
    case newThumbUpMessage(userId:String)
    case thumbUpMessageTime(userId:String)
    
    // 检查论坛回复我的消息
    case newForumReply2Me(userId:String)
    case forumReply2MeTime(userId:String)
    
}




extension MessegeHttpReq: TargetType{
    
    var prefix:String{
        return "message/"
    }
    
    var baseURL: URL {
        return URL.init(string: GlobalConfig.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .getNewMessage(let userID):
            return self.prefix + "user/:\(userID)"
        case .recruiterInfo(let userId):
            return self.prefix + "talkWith/\(userId)"
        case .newConversation(_,_,_):
            return self.prefix + "conversation"
        case .myVisitors(_):
            return self.prefix + "visitors"
        case .checkVisitor(_,_):
            return self.prefix + "visitor/status"
        case .visitorTime(let userId):
            return self.prefix + "visitorTime/\(userId)"
        case .newVisitor(let userId):
            return self.prefix + "newVisitor/\(userId)"
            
        case .newSystemMessage(let userId):
            return self.prefix + "newSystemMessage/\(userId)"
        case .systemMessageTime(let userId):
            return self.prefix  + "systemMessageTime/\(userId)"
        case .newThumbUpMessage(let userId):
            return self.prefix + "newThumbUp/\(userId)"
        case .thumbUpMessageTime(let userId):
            return self.prefix + "thumbUpTime/\(userId)"
        case .forumReply2MeTime(let userId):
            return self.prefix + "forumReplyTime/\(userId)"
        case .newForumReply2Me(let userId):
            return self.prefix + "newForumReply/\(userId)"
        }
    }
    
    var method: Moya.Method {
        switch  self {
        case .getNewMessage(_):
            return .get
        case .recruiterInfo(_):
            return .get
        case .newConversation(_,_,_):
            return .post
        case .myVisitors(_), .visitorTime(_):
            return .post
        case .newVisitor(_):
            return .get
        case .checkVisitor(_,_):
            return .put
        case .newSystemMessage(_):
            return .get
        case .systemMessageTime(_):
            return .post
        case .newThumbUpMessage(_):
            return .get
        case .thumbUpMessageTime(_):
            return .post
        case .newForumReply2Me(_):
            return .get
        case .forumReply2MeTime(_):
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getNewMessage(_):
            return "".utf8Encoded
        case .recruiterInfo(_):
            return "".utf8Encoded
        case .newConversation(_,_,_):
            return "".utf8Encoded
        default:
            return "".utf8Encoded
        
        }
    }
    
    var task: Task {
        switch self {
        case .getNewMessage(_):
            return .requestPlain
        case .recruiterInfo(_):
            return .requestPlain
        case let .newConversation(cid, rid, jid):
            return .requestParameters(parameters: ["conversation_id": cid, "recruiter_id":rid, "job_id":jid], encoding: JSONEncoding.default)
        case let .myVisitors(req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        case let .checkVisitor(userId, recruiterId):
            return .requestParameters(parameters: ["user_id": userId, "recruiter_id": recruiterId], encoding: JSONEncoding.default)
        case .visitorTime(_):
            return .requestPlain
        case .newVisitor(_):
            return .requestPlain
        case .newSystemMessage(_), .systemMessageTime(_), .newThumbUpMessage(_), .thumbUpMessageTime(_), .forumReply2MeTime(_), .newForumReply2Me(_):
            return .requestPlain
            
        }
    }
    
    var headers: [String : String]? {
        return ["Authorization": GlobalUserInfo.shared.getToken()]
    }
    
    
}



class MessageHttpServer{
    
    static let shared:MessageHttpServer = MessageHttpServer()
    private init(){}
    
    
    private lazy var httpServer:MoyaProvider<MessegeHttpReq> = {
        let s = MoyaProvider<MessegeHttpReq>(plugins: [NetworkLoggerPlugin(verbose: true)])
        return s
    }()
    
    
    
    func getUserLatestMessage(userID:String) -> Observable<[ConversationHRModel]>{
        return httpServer.rx.request(.getNewMessage(userID: userID)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInteractive)).asObservable().mapArray(ConversationHRModel.self, tag: "body")
    }
    
    func getRecruiterInfo(userId:String) -> Observable<ResponseModel<HRPersonModel>>{
        
        return httpServer.rx.request(.recruiterInfo(userId: userId)).retry(3).timeout(30, scheduler: MainScheduler.instance).observeOn(MainScheduler.instance).asObservable().mapObject(ResponseModel<HRPersonModel>.self)
        
    }
    
    
    func createConversation(conid:String, recruiteId:String, jobId:String) -> Observable<Bool>{
        return httpServer.rx.request(.newConversation(cid: conid, recruiterId:recruiteId,jobId:jobId)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).observeOn(MainScheduler.instance).asObservable().map({ (res)  in
            return HttpCodeRange.filterSuccessResponse(target: res.statusCode)
        }).asObservable()
        
    }
    
    
    func visitors(req: HttpVisitorReq) -> Observable<[MyVisitors]> {
        
        return httpServer.rx.request(.myVisitors(req: req)).retry(3).timeout(30, scheduler:  ConcurrentDispatchQueueScheduler.init(qos: .background)).observeOn(MainScheduler.instance).asObservable().mapArray(MyVisitors.self, tag: "body")
    }
    
    func updateVisitor(recruiterId:String, userId:String) {
        httpServer.request(.checkVisitor(userId: userId, recruiterId: recruiterId)) { result in
            print(result)
        }
        
    }
    
    func checkVisitorTime(userId:String){
        httpServer.request(.visitorTime(userId: userId)) { result in
              print(result)
        }
        
    }
    
    func hasNewVisitor(userId:String) -> Observable<ResponseModel<HasNewVisitor>>{
        return httpServer.rx.request(.newVisitor(userId: userId)).retry(3).timeout(30, scheduler:  ConcurrentDispatchQueueScheduler.init(qos: .background)).observeOn(MainScheduler.instance).asObservable().mapObject(ResponseModel<HasNewVisitor>.self)
    }
    
    
    func hasNewSystemMessage(userId: String) -> Observable<ResponseModel<HasNewSystemMessage>>{
        return httpServer.rx.request(.newSystemMessage(userId: userId)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).observeOn(MainScheduler.instance).asObservable().mapObject(ResponseModel<HasNewSystemMessage>.self)
    }
    
    
    func systemMessageTime(userId: String) {
        httpServer.request(.systemMessageTime(userId: userId)) { result in
            print(result)
        }
    }
    
    func HasNewThumbUpMessage(userId:String) -> Observable<ResponseModel<HasNewThumbUpMessage>> {
        
        return httpServer.rx.request(.newThumbUpMessage(userId: userId)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).observeOn(MainScheduler.instance).asObservable().mapObject(ResponseModel<HasNewThumbUpMessage>.self)
    }
    
    func thumbUpMessageTime(userId:String){
        httpServer.request(.thumbUpMessageTime(userId: userId)) { (result) in
            print(result)
        }
    }
    
    
    func HasNewForumReply2Me(userId:String) -> Observable<ResponseModel<HasForumReply2Me>>{
        return httpServer.rx.request(.newForumReply2Me(userId: userId)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).observeOn(MainScheduler.instance).asObservable().mapObject(ResponseModel<HasForumReply2Me>.self)
    }
    
    func forumReplyTime(userId:String){
        
        httpServer.request(.forumReply2MeTime(userId: userId)) { (result) in
            print(result)
        }
    }
}

