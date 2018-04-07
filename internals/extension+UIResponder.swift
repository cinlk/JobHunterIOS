//
//  extension+UIResponder.swift
//  internals
//
//  Created by ke.liang on 2018/4/7.
//  Copyright © 2018年 lk. All rights reserved.
//

import Foundation

extension UIResponder{
    // 找到view 的第一个viewcontroller
    func getParentViewController() -> UIViewController? {
        if self.next is UIViewController {
            return self.next as? UIViewController
        } else {
            if self.next != nil {
                return (self.next!).getParentViewController()
            }
            else {return nil}
        }
    }
}
