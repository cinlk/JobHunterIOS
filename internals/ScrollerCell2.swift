//
//  MainPageRecommandCell.swift
//  internals
//
//  Created by ke.liang on 2017/9/2.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class MainPageRecommandCell: UITableViewCell,UIScrollViewDelegate {

   
    lazy var scroller:UIScrollView = {
        
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator =  false
        scroll.showsVerticalScrollIndicator = false
        scroll.bounces = false
        scroll.isPagingEnabled = false
        scroll.clipsToBounds = true
        scroll.isUserInteractionEnabled = true
        scroll.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        return scroll
    }()
    
    lazy   var topView:UIView = {
        
        var uiview = UIView()
        var label:UILabel  = UILabel()
        label.text = "热门推荐"
        //label.font = UIFont(name: "Bobz Type", size: 5)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor  =  0.5
        label.font = UIFont.systemFont(ofSize: 10)
        uiview.addSubview(label)
        label.frame  = CGRect(x: 5, y: 1, width: 120, height: 10)
        return uiview
        
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle  = .none
        
        self.build()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func  build(){
        
        self.addSubview(topView)
        self.addSubview(scroller)

        
        _ = topView.sd_layout().topEqualToView(self.contentView)?.leftEqualToView(self.contentView)?.widthRatioToView(self.contentView,1)?.heightIs(15)
        
        
        
    }
    
    func createScroller(items:[String],width:CGFloat){
     
        //stackview
        scroller.subviews.forEach{$0.removeFromSuperview()}
        scroller.frame  = CGRect(x: 0, y: 15, width: self.contentView.frame.width-75, height: self.frame.height-10)
        
        
        for i in 0..<items.count{
            
            //let stackview = UIView(frame: CGRect(x: CGFloat(i)*width, y: 0, width: width, height: self.frame.height-10))
            
            let pview =  UIView()
            
            let button = UIButton(type: .custom)
            //imagebackgroud.frame = stackview.frame
            //button.frame = CGRect(x: CGFloat(i)*width, y: 0, width: width-5, height: self.frame.height-10)
            //imagebackgroud.image = UIImage(named: items[i])
            //imagebackgroud.isUserInteractionEnabled = true
            //imagebackgroud.contentMode = .scaleAspectFit
            pview.frame  = CGRect(x: CGFloat(i)*width, y: 2, width: width-5, height: self.frame.height-10)
            
            button.backgroundColor  = UIColor.clear
            button.setImage(UIImage(named: items[i]), for: .normal)
            
            button.imageView?.contentMode = .scaleAspectFill
            button.imageView?.clipsToBounds = true
            button.imageView?.alpha = 0.4
            button.alpha = 0.5
            button.isHidden  = false
            button.addTarget(self, action: #selector(click(button:)), for: .touchUpInside)
            
            //imagebackgroud.alpha =  0.5
             let label =  UILabel(frame: CGRect(x: 5, y: 5, width: 40, height: 20))
             label.text = items[i]
             label.font = UIFont.boldSystemFont(ofSize: 10)
             label.textColor = UIColor.black
             label.alpha = 1
             pview.addSubview(button)
             pview.addSubview(label)
             button.sd_layout().leftSpaceToView(pview,5)?.rightEqualToView(pview)?.heightRatioToView(pview,1)?.widthRatioToView(pview,1)
            
            
            
            
             scroller.addSubview(pview)
            
            
        }
        
        scroller.contentSize =  CGSize(width: CGFloat(items.count) * width, height: self.frame.height-10)
        scroller.backgroundColor = UIColor.white
        scroller.delegate  = self
     
        
    }
    
    @objc func click(button:UIButton){
        print("click")
    }
    
    
}
