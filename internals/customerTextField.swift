//
//  customerTextField.swift
//  internals
//
//  Created by ke.liang on 2018/5/25.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class customerTextField: UITextField {

    
    internal var leftPadding:CGFloat = 0
    internal var righPadding:CGFloat = 0
    internal var insect:CGFloat = 10
    internal var showLine:Bool = true
    
    private lazy var line:UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        view.alpha = 0.7
        view.isHidden = true
        return view
    }()
    
    
    internal var leftImage:UIImageView?{
        didSet{
            setLeftImage()
        }
    }
    
    internal var rightBtn:UIButton?{
        didSet{
            setRightBtn()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(line)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += leftPadding
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= righPadding
        if rightView != nil && showLine{
            line.isHidden = false
            _ = line.sd_layout().rightSpaceToView(rightView,1)?.centerYEqualToView(rightView)?.widthIs(1)?.heightRatioToView(self,0.6)

        }
        return rect
    }
    // 调整内容框架与周边间距
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.origin.x += leftPadding
        rect.size.width -= leftPadding  + 10
        return rect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        rect.origin.x += leftPadding
        rect.size.width -= leftPadding  + 10
        return rect
        
    }




}

extension customerTextField{
    private func setLeftImage(){
        if let imageView = leftImage{
            leftViewMode = UITextFieldViewMode.always
            leftView = imageView
            
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
    }
    
    private func setRightBtn(){
        if let btn = rightBtn{
            rightViewMode = UITextFieldViewMode.always
            rightView = btn
            
           
            
            
            
        }else{
            rightView = nil
            rightViewMode = .never
            
            
        }
    }
}
