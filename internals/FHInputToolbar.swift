//
//  FHInputToolbar.swift
//  internals
//
//  Created by ke.liang on 2017/10/14.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

protocol FHInputToolbarDelegate {
    func onInputBtnTapped(text:String)
    func onleftBtnTapped(text:String)
    func showMoreView()
}



class FHInputToolbar: UIView,UITextFieldDelegate {

    
    var backgroundImageView:UIImageView!
    var textFiledBackgroud:UIImageView!
    var textField:UITextField!
    var leftBtn:UIButton!
    var rightBtn:UIButton!
    
    
    
   
//    lazy var moreView:ChatMMoreView  = { [unowned self] in
//        let moreV = ChatMMoreView()
//        moreV.delegate = self
//        return moreV
//
//
//        }()
    
    var delage:FHInputToolbarDelegate?
    
    
    override init(frame: CGRect) {
        self.backgroundImageView = UIImageView()
        self.textFiledBackgroud = UIImageView()
        self.textField = UITextField()
        
        self.leftBtn = UIButton.init(type: .custom)
        self.rightBtn = UIButton.init(type: .custom)
        super.init(frame: frame)
        
        self.frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: UIScreen.main.bounds.width, height: 44)
        
        
        self.backgroundImageView.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        self.backgroundImageView.image = UIImage.resizeableImage(name: "b1")
        self.addSubview(self.backgroundImageView)
        
        self.leftBtn.frame = CGRect.init(x: 5, y: 5, width: 34, height: 34)
        self.leftBtn.setBackgroundImage(UIImage.init(named: "voice"), for: .normal)
        self.leftBtn.addTarget(self, action: #selector(leftclick), for: .touchUpInside)
        self.addSubview(leftBtn)
        
        self.textFiledBackgroud.frame = CGRect.init(x: 34+10, y: 5, width: UIScreen.main.bounds.width-34-10-34-10, height: 34)
        
        self.textFiledBackgroud.image = UIImage.init(named: "b2")
        
        self.addSubview(self.textFiledBackgroud)
        
        self.textField.frame = CGRect.init(x: self.textFiledBackgroud.frame.origin.x+5, y: 5, width: self.textFiledBackgroud.frame.width-10, height: 34)
        
        self.textField.borderStyle = UITextBorderStyle.none
        self.textField.placeholder = "请输入"
        self.textField.delegate = self
        self.textField.keyboardType = .default
        
      
        self.addSubview(textField)
        
        self.rightBtn.frame = CGRect.init(x: UIScreen.main.bounds.width-34-5, y: 5, width: 34, height: 34)
        // more
        self.rightBtn.setBackgroundImage(UIImage.init(named: "plus"), for: .normal)
        
        self.rightBtn.addTarget(self, action: #selector(rightclick), for: .touchUpInside)
        
        self.addSubview(rightBtn)
        
        //self.addSubview(moreView)
        
       // _ = moreView.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.heightIs(self.textField.height)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension FHInputToolbar{
    func leftclick(sender:AnyObject){
        self.delage?.onleftBtnTapped(text: self.textField.text!)
        self.textField.text = ""
    }
    func rightclick(sender:AnyObject){
        
        //self.delage?.onInputBtnTapped(text: self.textField.text!)
        self.delage?.showMoreView()
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //需要扩展
        //self.rightclick(sender: self.rightBtn)
        self.delage?.onInputBtnTapped(text: self.textField.text!)
        self.textField.text = ""
        return false
        
    }
}

// MARK
extension FHInputToolbar: MoreViewDelegate{
    func chatMoreView(moreView: ChatMMoreView, didSelectedType type: ChatMoreType) {
        
    }
    
    
}
