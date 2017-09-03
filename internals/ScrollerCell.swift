//
//  ScrollerCell.swift
//  internals
//
//  Created by ke.liang on 2017/9/2.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class ScrollerCell: UITableViewCell,UIScrollViewDelegate{

    
    
    var scrollView:UIScrollView?
    var event:UIGestureRecognizer?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.build()
    }
    
    func build(){
        print("init cell")
        scrollView = UIScrollView.init(frame: self.frame)
        scrollView?.delegate = self
        scrollView?.showsHorizontalScrollIndicator = false

        

    }
    


    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    func createScroller(images:[String],width:Int){
        
        scrollView?.subviews.forEach{$0.removeFromSuperview()}
        for i in 0..<images.count{
            let button = UIButton(frame: CGRect(x: i*width, y: 0, width: width,height: Int(self.frame.height) - 35))
            let label = UILabel()
            scrollView?.addSubview(button)
            scrollView?.addSubview(label)
            _ = label.sd_layout().topSpaceToView(button,0.1)?.bottomSpaceToView(scrollView,10)?.widthIs(CGFloat(width))?.heightIs(20)?.centerXEqualToView(button)
            
            label.text = images[i]
            label.font = UIFont(name: "Bobz Type", size: 10)
            label.textAlignment = .center
            label.textColor = UIColor.black
            button.backgroundColor  = UIColor.white
            button.setImage(UIImage(named:images[i]), for: .normal)
            button.addTarget(self, action: #selector(demo(button:)), for: .touchUpInside)
            button.titleLabel?.text = images[i]
            
            
        }
        
        
        self.isUserInteractionEnabled = true
        scrollView?.isUserInteractionEnabled = true
        scrollView?.bounces = false
        scrollView?.isPagingEnabled = false
        scrollView?.height = self.frame.height
        scrollView?.contentSize  = CGSize(width: images.count*width, height: Int(self.frame.height))
        scrollView?.canCancelContentTouches  = true
       
        self.addSubview(scrollView!)
    
        

        
        
    }
    
    func demo(button:UIButton){
        print("image \(button.titleLabel?.text)")
        
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    


}
