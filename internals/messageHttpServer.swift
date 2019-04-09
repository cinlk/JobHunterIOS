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
        default:
            return ""
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
        return httpServer.rx.request(.newConversation(cid: conid, recruiterId:recruiteId,jobId:jobId)).retry(3).timeout(30, scheduler:MainScheduler.instance).observeOn(MainScheduler.instance).asObservable().map({ (res)  in
            return HttpCodeRange.filterSuccessResponse(target: res.statusCode)
        }).asObservable()
    }
}

