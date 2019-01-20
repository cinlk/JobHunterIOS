//
//  customerTextField.swift
//  internals
//
//  Created by ke.liang on 2018/5/25.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class CustomerTextField: UITextField {

    
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
       
    }
    
    override func layoutSubviews() {
       
        self.addSubview(line)
        self.textAlignment = .left
        self.clearButtonMode = .whileEditing
        self.font = UIFont.systemFont(ofSize: 16)
        self.borderStyle = .roundedRect
        super.layoutSubviews()
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

extension CustomerTextField{
    private func setLeftImage(){
        if let imageView = leftImage{
            leftViewMode = UITextField.ViewMode.always
            leftView = imageView
            
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
    }
    
    private func setRightBtn(){
        if let btn = rightBtn{
            rightViewMode = UITextField.ViewMode.always
            rightView = btn
        }else{
            rightView = nil
            rightViewMode = .never
            
            
        }
    }
}
