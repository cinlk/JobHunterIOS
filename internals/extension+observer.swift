//
//  extension+observer.swift
//  internals
//
//  Created by ke.liang on 2017/11/18.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


// 成为观察者
extension Reactive where Base: UILabel{
    
    var rxob: Binder<Result>{
        return Binder.init(self.base){ (label, v) in
            label.textColor = v.textColor
            label.text = v.describtion
           
        }
    }
}




extension ObservableConvertibleType{
    public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<E> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}
