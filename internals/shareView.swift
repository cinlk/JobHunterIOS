//
//  shareView.swift
//  internals
//
//  Created by ke.liang on 2017/9/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate var ROWNUMBERS = 1
fileprivate let COLUME = 4

class shareView: UIView {


    var images:[String] = ["qq","sina","wechat","link","chrome","car","",""]
    // 
    var sharedata:String?
    
    
    lazy var stackview:UIStackView = {
       let sk = UIStackView.init()
        sk.axis = .vertical
        sk.alignment = UIStackViewAlignment.fill
        sk.distribution = .fillEqually
        sk.spacing = 10
        return sk
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(stackview)
        _ = stackview.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.topEqualToView(self)
        
         self.buildStackIcon()
        
        

    }

    
    private func buildStackIcon(){
        ROWNUMBERS = ( images.count / COLUME )  + ( images.count % COLUME == 0 ? 0 : 1)
        var j = 0
        var step = COLUME
        for i in 0..<ROWNUMBERS{
            
            
            let stack = UIStackView.init()
            //stack.alignment = .fill
            stack.axis = .horizontal
            stack.spacing = 20
            stack.distribution = .fillEqually
            
            
            j = i*COLUME
            if i  == ROWNUMBERS - 1 {
                step = min(j+COLUME, self.images.count) - COLUME
            }
            for k in j..<j+step{
                let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 75))
                view.backgroundColor = UIColor.white
                
                let btn =  UIButton.init()
                btn.backgroundColor = UIColor.clear
                btn.setImage(UIImage.init(named: images[k]), for: .normal)
                btn.addTarget(self, action: #selector(click), for: .touchUpInside)
                btn.setTitle(images[k], for: .normal)
                
                
                let text = UILabel.init()
                text.font = UIFont.systemFont(ofSize: 14)
                text.text = images[k]
                text.textAlignment = .center
                
                view.addSubview(btn)
                view.addSubview(text)
                _ = btn.sd_layout().leftSpaceToView(view,10)?.rightSpaceToView(view,10)?.topSpaceToView(view,5)?.heightIs(45)
                _ = text.sd_layout().topSpaceToView(btn,2)?.leftEqualToView(btn)?.rightEqualToView(btn)?.bottomSpaceToView(view,5)
                
                stack.addArrangedSubview(view)
                
            }
            
            stackview.addArrangedSubview(stack)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension shareView{
 
   @objc func click(sender:UIButton){
    if let text = sender.titleLabel?.text{
            switch text{
            case "qq":
                print("qq 分享")
            case "sina":
                print("sina 分享")
            default:
                break
            }
    }
    
    }

}
