//
//  utils.swift
//  internals
//
//  Created by ke.liang on 2017/12/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import Foundation
import SwiftDate


//
public func  build_image(frame: CGRect, color:UIColor)->UIImage{
    
    UIGraphicsBeginImageContext(frame.size)
    let context:CGContext = UIGraphicsGetCurrentContext()!
    context.setFillColor(color.cgColor)
    context.fill(frame)
    
    let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return image
    
    
    
}



public func getCitys(filename:String)->[String:[String]]{
    
    guard  let filePath = Bundle.main.path(forResource: filename, ofType: "plist")else{
        
        
        return [:]
    }
    guard  let citys = NSDictionary.init(contentsOfFile: filePath) as? [String:[String]] else {
        
        return [:]
    }
    
    return citys
    
    
}


func showAlert(error:String, vc:UIViewController){
    let action = UIAlertAction.init(title: "确定", style: .default, handler: nil)
    let alertView = UIAlertController.init(title: nil, message: error, preferredStyle: .alert)
    alertView.addAction(action)
    vc.present(alertView, animated: true, completion: nil)
}




struct showitem {
    
    var name:String?
    var image:String?
    var bubbles:Int?
    
}



func buildStackItemView(items:[showitem]?, ItemRowNumbers:Int, mainStack:UIStackView?, itemButtons:inout [UIButton]?){
    guard let items = items else {
        return
    }
    let count = items.count
    let row = count / ItemRowNumbers + (count % ItemRowNumbers == 0 ? 0: 1)
    
    var start = 0
    var step = ItemRowNumbers
    
    for i in 0..<row{
        let  stack = UIStackView.init()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        //
        start = i*ItemRowNumbers
        if i == row - 1 {
            step = min(start + ItemRowNumbers, count) - ItemRowNumbers
        }
        for index in start..<start + step{
            let view = UIView.init(frame: CGRect.zero)
            view.backgroundColor = UIColor.white
            let btn = UIButton.init()
            btn.tag = index
            let img = UIImage.barImage(size: CGSize.init(width: 30, height: 30), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: items[index].image!)
            btn.setImage(img, for: .normal)
            btn.backgroundColor = UIColor.clear
            
            itemButtons?.append(btn)
            
            let  lable = UILabel.init()
            lable.font = UIFont.systemFont(ofSize: 14)
            lable.text =  items[index].name
            lable.textAlignment = .center
            
            view.addSubview(btn)
            view.addSubview(lable)
            
            _ = btn.sd_layout().leftSpaceToView(view,10)?.rightSpaceToView(view,10)?.topSpaceToView(view,5)?.heightIs(45)
            _ = lable.sd_layout().topSpaceToView(btn,2)?.leftEqualToView(btn)?.rightEqualToView(btn)?.bottomSpaceToView(view,5)
            
            stack.addArrangedSubview(view)
        }
        
        mainStack?.addArrangedSubview(stack)
    }
    
    
}


func chatTimeString(with modelTime: TimeInterval?) -> String? {
    guard let time = modelTime else {
        return nil
    }
    // 消息时间
    let date = Date(timeIntervalSince1970: time)
    let dateInRome = DateInRegion(absoluteDate: date)
    // 当前时间
    let now = DateInRegion()
    
    // 相差年份
    let year = now.year - dateInRome.year
    // 相差月数
    let month = now.month - dateInRome.month
    // 相差天数
    let day = now.day - dateInRome.day
    // 相差小时
    let hour = now.hour - dateInRome.hour
    // 相差分钟
    let minute = now.minute - dateInRome.minute
    // 相差秒数
    let second = now.second - dateInRome.second
    
    if year != 0 {
        return String(format: "%d年%d月%d日 %d:%02d", dateInRome.year, dateInRome.month, dateInRome.day, dateInRome.hour, dateInRome.minute)
    } else if year == 0 {
        if month > 0 || day > 7 {
            return String(format: "%d月%d日 %d:%02d", dateInRome.month, dateInRome.day, dateInRome.hour, dateInRome.minute)
        } else if day > 2 {
            return String(format: "%@ %d:%02d", dateInRome.weekdayName, dateInRome.hour, dateInRome.minute)
        } else if day == 2 {
            return String(format: "前天 %d:%d", dateInRome.hour, dateInRome.minute)
        } else if dateInRome.isYesterday {
            return String(format: "昨天 %d:%d", dateInRome.hour, dateInRome.minute)
        } else if hour > 0 {
            return String(format: "%d:%02d",dateInRome.hour, dateInRome.minute)
        } else if minute > 0 {
            return String(format: "%02d分钟前",minute)
        } else if second > 3 {
            return String(format: "%d秒前",second)
        } else  {
            return String(format: "刚刚")
        }
    }
    return ""
}

// 间隔 时间  显示 time
func needAddMinuteModel(preModel: MessageBoby, curModel: MessageBoby) -> Bool {
    
    let preTime = preModel.time
        
    let curTime = curModel.time
    
    let preDate = Date(timeIntervalSince1970: preTime)
    let preInRome = DateInRegion(absoluteDate: preDate)
    let curDate = Date(timeIntervalSince1970: curTime)
    let curInRome = DateInRegion(absoluteDate: curDate)
    
    let yesr = curInRome.year - preInRome.year
    let month = curInRome.month - preInRome.month
    let day = curInRome.day - preInRome.day
    let hour = curInRome.hour - preInRome.hour
    let minute = curInRome.minute - preInRome.minute
    if yesr > 0 || month > 0 || day > 0 || hour > 0 {
        return true
    } else if minute >= 1 {
        return true
    } else {
        return false
    }
}

