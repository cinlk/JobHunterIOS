//
//  JobTagsCell.swift
//  internals
//
//  Created by ke.liang on 2017/12/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate let ROWITEMS:Int = 4

@objcMembers class JobTagsCell: UITableViewCell {
    
    
    private var btns:[UIButton] = []
    
    private var currentSelected:Int = 0
    
    private lazy var btnView:UIView = UIView()
    
    dynamic var mode:[String]?{
        didSet{
            guard  let mode = mode  else {
                return
            }
            
            btns.removeAll()
            self.btnView.subviews.forEach{$0.removeFromSuperview()}
            for (index, str) in  mode.enumerated(){
               
                let btn = UIButton.init(frame: CGRect.zero)
                btn.setTitle(str, for: .normal)
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.setTitleColor(UIColor.white, for: .selected)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                btn.backgroundColor = UIColor.white
                btn.titleLabel?.textAlignment = .center
                // 第一次加载
                if index == 0 && currentSelected == 0 {
                    btn.isSelected = true
                    btn.backgroundColor = UIColor.blue
                // 重用cell 时
                }else if index == currentSelected{
                    btn.isSelected = true
                    btn.backgroundColor = UIColor.blue
                }
        
                btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
                btns.append(btn)
                btnView.addSubview(btn)
                
                // 这里设置高宽比
                _ = btn.sd_layout().autoHeightRatio(3/8)

            }
            // 这里设置width 浮动长度
            let itemWidth = GlobalConfig.ScreenW - 20 - 10 -  CGFloat(ROWITEMS-1)*5
            
            self.btnView.setupAutoMarginFlowItems(btns, withPerRowItemsCount: ROWITEMS, itemWidth: itemWidth/CGFloat(ROWITEMS), verticalMargin: 10, verticalEdgeInset: 5, horizontalEdgeInset: 5)
            self.setupAutoHeight(withBottomView: btnView, bottomMargin: 10)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.init(r: 230, g: 230, b: 250)
        self.contentView.addSubview(btnView)
        _ = btnView.sd_layout().leftSpaceToView(self.contentView,10)?.rightSpaceToView (self.contentView,10)?.topSpaceToView(self.contentView,10)?.heightIs(0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "JobTagsCell"
    }
}

extension JobTagsCell{
    //
    @objc private func click(_ btn:UIButton){
        //改变btn 状态
        btns[currentSelected].isSelected = false
        btns[currentSelected].backgroundColor = UIColor.white
        
        btn.isSelected = true
        btn.backgroundColor = UIColor.blue
        currentSelected = btns.index(of: btn)!
        
        // 消息通知刷新tableview
        if let tag = btn.titleLabel?.text{
            NotificationCenter.default.post(name: NSNotification.Name.init(JOBTAG_NAME), object: tag)
        }
        
        
    }
}


