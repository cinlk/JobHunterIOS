////
////  PreShowPDFVC-viewModel.swift
////  internals
////
////  Created by ke.liang on 2019/1/6.
////  Copyright © 2019 lk. All rights reserved.
////
//
//import Foundation
//import RxCocoa
//import RxSwift
//
//
//
//
//class PreShowPDFVCViewModel{
//    
//    public var fileURL:URL?
//    
//    private var dispose = DisposeBag.init()
//    public var btnTab:PublishSubject<Void> = PublishSubject.init()
//    
//    
//    
//    private lazy var  service: ResumeHttpClient  = {
//        return ResumeHttpClient.init()
//    }()
//    
//    public var uploadResult:PublishSubject<Bool> = PublishSubject<Bool>.init()
//    
//    
//    
//    init() {
//        btnTab.subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .userInteractive)).subscribe(onNext: {
//                //sleep(10)
//                self.uploadResult.onNext(false)
//            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
//    }
//    
//}
