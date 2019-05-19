//
//  PersonServer.swift
//  internals
//
//  Created by ke.liang on 2019/5/18.
//  Copyright © 2019 lk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya





internal enum personTarget{
    case userAvatar(imageData:Data, imageName:String)
    case userBrief(req: PersonBriefReq)
    case delivery
    case deliveryStatus(jobId:String, type:String)
    case getOnlineApplyId(positionId:String)
    case none
}


extension personTarget: TargetType{
    
    var baseURL: URL {
        return URL.init(string: GlobalConfig.BASE_URL)!
    }
    
    var prefix:String{
        return "person"
    }
    
    var path: String {
        switch self {
        case .userAvatar:
            return self.prefix + "/avatar"
        case .userBrief:
            return self.prefix + "/brief"
        case .delivery:
            return self.prefix + "/delivery"
        case .deliveryStatus(let jobId, let type):
            return self.prefix + "/delivery/history/\(type)/\(jobId)"
        case .getOnlineApplyId(let positionId):
            return self.prefix + "/onlineApplyId/\(positionId)"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch  self {
        case .userAvatar, .userBrief:
            return .post
        case .delivery, .deliveryStatus, .getOnlineApplyId:
            return .get
        default:
            return .get
        }
    }
    
    var sampleData: Data {
         return "".utf8Encoded
    }
    
    var task: Task {
        switch  self {
        case .userAvatar(let imageData, let imageName):
            
            let formData: [Moya.MultipartFormData] = [Moya.MultipartFormData(provider: .data(imageData), name: "avatar", fileName: imageName, mimeType: "image/jpeg")]
            
            return .uploadMultipart(formData)
            //return .uploadCompositeMultipart([formData], urlParameters: [])
        case .userBrief(let req):
            return .requestParameters(parameters: req.toJSON(), encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return  ["Content-Type": "application/json", "Authorization": GlobalUserInfo.shared.getToken()]
    }
    
    
}






class PersonServer {
    
   
    static let shared: PersonServer = PersonServer.init()
    private lazy var httpServer: MoyaProvider<personTarget> = {
        let s = MoyaProvider<personTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])
        return s
    }()
    
    private init() {}
}


extension PersonServer{
    
    internal func updateAvatar(data:Data, name:String) -> Observable<ResponseModel<HttpAvatarResModel>>{
        
        
        return self.httpServer.rx.request(.userAvatar(imageData: data, imageName: name)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpAvatarResModel>.self)
    }
    
    internal func updatePersonBrief(req: PersonBriefReq) -> Observable<ResponseModel<HttpResultMode>> {
        return httpServer.rx.request(.userBrief(req: req)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<HttpResultMode>.self)
    }
    
    
    internal func deliveryHistory() -> Observable<[DeliveryJobsModel]>{
        return httpServer.rx.request(.delivery).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapArray(DeliveryJobsModel.self, tag: "body")
    }
    
    internal func deliveryHistoryStatus(jobId:String, type:String) -> Observable<[DeliveryHistoryStatus]> {
        return httpServer.rx.request(.deliveryStatus(jobId: jobId, type: type)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapArray(DeliveryHistoryStatus.self, tag: "body")
    }
    
    
    internal func getOnlineApplyId(positionId:String) -> Observable<ResponseModel<OnlineApplyId>>{
        return httpServer.rx.request(.getOnlineApplyId(positionId: positionId)).retry(3).timeout(30, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background)).asObservable().observeOn(MainScheduler.instance).mapObject(ResponseModel<OnlineApplyId>.self)
    }
}
