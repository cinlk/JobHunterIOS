//
//  JobTagsCell.swift
//  internals
//
//  Created by ke.liang on 2017/12/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate let ROWITEMS = 4

@objcMembers class JobTagsCell: UITableViewCell {
    
    private var onece  = true
    private var btns:[UIButton] = []
    
    private var currentSelectedBtn:UIButton?
    
    private lazy var btnView:UIView = UIView()
    
    dynamic var mode:[String]?{
        didSet{
            btns.removeAll()
            self.btnView.subviews.forEach{$0.removeFromSuperview()}
            for (index, str) in  mode!.enumerated(){
               
                let btn = UIButton.init(frame: CGRect.zero)
                btn.setTitle(str, for: .normal)
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.setTitleColor(UIColor.white, for: .selected)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                btn.backgroundColor = UIColor.white
                btn.titleLabel?.textAlignment = .center
                if index == 0 {
                    btn.isSelected = true
                    btn.backgroundColor = UIColor.blue
                    currentSelectedBtn = btn
                }
        
                btn.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
                btns.append(btn)
                btnView.addSubview(btn)
                
                // 这里设置高宽比
                _ = btn.sd_layout().autoHeightRatio(3/8)

            }
            // 这里设置width 浮动长度
            self.btnView.setupAutoMarginFlowItems(btns, withPerRowItemsCount: ROWITEMS, itemWidth: 80, verticalMargin: 10, verticalEdgeInset: 5, horizontalEdgeInset: 5)        
            self.setupAutoHeight(withBottomView: btnView, bottomMargin: 10)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.lightGray
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
        currentSelectedBtn?.isSelected = false
        currentSelectedBtn?.backgroundColor = UIColor.white
        
        btn.isSelected = true
        btn.backgroundColor = UIColor.blue
        currentSelectedBtn = btn
        
        // 消息通知刷新tableview
        if let tag = btn.titleLabel?.text{
            NotificationCenter.default.post(name: NSNotification.Name.init("whichTag"), object: tag)
        }
        
        
    }
}


