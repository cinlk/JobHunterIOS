//
//  popView.swift
//  internals
//
//  Created by ke.liang on 2018/7/11.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class popView: UIView {

    
    private lazy var title:UILabel = { [unowned self] in
        let t = UILabel()
        t.textAlignment = .center
        t.font = UIFont.boldSystemFont(ofSize: 14)
        t.setSingleLineAutoResizeWithMaxWidth(self.bounds.width)
        
        return t
    }()
    
    
    private lazy var backView:UIButton = {
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH))
        btn.alpha = 0.5
        btn.backgroundColor = UIColor.lightGray
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
        return btn
    }()
    
    
    private lazy var line:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(title)
        self.addSubview(line)
        _ = title.sd_layout().centerXEqualToView(self)?.topSpaceToView(self,5)?.autoHeightRatio(0)
        _ = line.sd_layout().topSpaceToView(title,2.5)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension popView{
    
    open func showPop(height:CGFloat = 0){
        
       self.frame.size.height = height
        
       UIApplication.shared.keyWindow?.insertSubview(backView, belowSubview: self)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.frame.origin.x = (ScreenW  - 200)/2
            
        }, completion: nil)
        
    }
    
    @objc open func dismiss(){
        
        
        backView.removeFromSuperview()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.frame.origin.x = -300
        }, completion: { bool in
            self.viewWithTag(10)?.removeFromSuperview()
        })
        
    }
}

extension popView{
    open func setTitleAndView(title:String, view:UIView){
        self.title.text = title
        view.tag = 10
        self.addSubview(view)
        // 判断不同类型view
        if view.isKind(of: UILabel.self){
            
            _ = view.sd_layout().topSpaceToView(line,5)?.leftSpaceToView(self,5)?.autoHeightRatio(0)
        }else if view.isKind(of: UITableView.self){
            _ = view.sd_layout().topSpaceToView(line,5)?.leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)
            (view as! UITableView).reloadData()
        }
    }
}


