//
//  shareView.swift
//  internals
//
//  Created by ke.liang on 2017/9/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

protocol  closeshare {
    func exit()
}

class shareView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var scrollapps:UIScrollView!
    var exit:closeshare?
    var images:[String]!
    var separateView:UIView!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        images = ["qq","sina","wechat","link","chrome"]
        self.bottomView()
        self.builScroll()

        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func builScroll(){
        scrollapps  = UIScrollView()
        scrollapps.showsVerticalScrollIndicator = false
        scrollapps.showsHorizontalScrollIndicator = false
        scrollapps.isPagingEnabled = false
        scrollapps.isUserInteractionEnabled = true
        scrollapps.bounces = true
        
        
        let width:Int = 60
        
        for i in 0..<images.count{
            let button = UIButton(frame: CGRect(x: i*(width+20), y: 2, width: width,height: 45))
            let label = UILabel()
            scrollapps?.addSubview(button)
            scrollapps?.addSubview(label)
            _ = label.sd_layout().topSpaceToView(button,0.5)?.bottomSpaceToView(scrollapps,5)?.widthIs(CGFloat(width))?.heightIs(10)?.centerXEqualToView(button)
            
            label.text = images[i]
            label.font =  UIFont.systemFont(ofSize: 10)
            label.textAlignment = .center
            label.textColor = UIColor.black
            button.backgroundColor  = UIColor.white
            button.imageView?.clipsToBounds = true
            button.setImage(UIImage(named:images[i]), for: .normal)
            button.addTarget(self, action: #selector(click(button:)), for: .touchUpInside)
            button.titleLabel?.text = images[i]
            
            
        }

        
        scrollapps.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        scrollapps.contentSize  = CGSize(width: CGFloat((images.count)*(width + 15)), height: 60)
        
        
        self.addSubview(scrollapps)
        _ = scrollapps.sd_layout().topEqualToView(self)?.widthIs(self.frame.width)?.bottomSpaceToView(self.separateView,1)
        
    }
    
    private func bottomView(){
        let cancelButton:UIButton =  UIButton()
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.layer.borderWidth = 0
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        separateView = UIView()
        separateView.backgroundColor = UIColor.gray
        
        
        self.addSubview(cancelButton)
        self.addSubview(separateView)
        
        _ = cancelButton.sd_layout().bottomSpaceToView(self,5)?.centerXEqualToView(self)?.widthIs(40)?.heightIs(20)
        _ = separateView.sd_layout().bottomSpaceToView(cancelButton,5)?.widthIs(self.frame.width)?.heightIs(5)
        

        
    }
    
    func cancel(){
        exit?.exit()
        
    }

    
    
}

extension shareView{
    func click(button:UIButton){
        print("click to share")
        
    }

}
