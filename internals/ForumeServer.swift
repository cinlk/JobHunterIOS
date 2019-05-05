
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
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postItem(_):
            return .post
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
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
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
    
    
}
