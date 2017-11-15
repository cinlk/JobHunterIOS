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
    
    
    // 闭包回调传值
    typealias myblock = (_ str: String) -> Void
    
    var callBack:myblock?
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.build()
    }
    
    func build(){
        print("init cell")
        scrollView = UIScrollView.init(frame: self.contentView.frame)
        scrollView?.delegate = self
        scrollView?.showsHorizontalScrollIndicator = false
        
        self.isUserInteractionEnabled = true
        scrollView?.isUserInteractionEnabled = true
        scrollView?.bounces = false
        scrollView?.isPagingEnabled = false
        //scrollView?.height = self.frame.height
        scrollView?.canCancelContentTouches  = true
        
        self.contentView.addSubview(scrollView!)

        

    }
    


    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // create job tag button
    func createJobTags(name:[String], width:Int){
        scrollView?.subviews.forEach{$0.removeFromSuperview()}
        
        for  i in  0..<name.count{
            let tagButton = UIButton.init()
            tagButton.backgroundColor = UIColor.white
            tagButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            //tagButton.tag = 100 + i
            tagButton.setTitle(name[i], for: .normal)
            tagButton.setTitleColor(UIColor.gray, for: .normal)
            tagButton.setTitleColor(UIColor.white, for: .selected)
            
            tagButton.addTarget(self, action: #selector(tag(button:)), for: .touchUpInside)
            tagButton.frame = CGRect(x: i*(width+5), y: 12, width: width, height: 20)
            tagButton.layer.borderWidth = 0.5
            if i == 0 {
                // 全部button
                tagButton.isSelected = true
                tagButton.backgroundColor = UIColor.blue
            }
            scrollView?.addSubview(tagButton)
        }
        
        scrollView?.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        self.backgroundColor = UIColor.lightGray
        scrollView?.height  = self.contentView.frame.height
        scrollView?.contentSize  = CGSize(width: name.count*(width+5), height: Int(self.frame.height))
        
    }
    
    //
    func  SetCallBack(_ block: @escaping myblock){
        
            callBack = block
    }
    
    @objc func tag(button:UIButton){
        
        print(button.titleLabel?.text ?? "")
        for bu  in (self.scrollView?.subviews)!{
            
            if bu.isKind(of: UIButton.self){
                if button ==  bu as! UIButton{
                button.backgroundColor = UIColor.blue
                button.isSelected = true
                
                    if callBack != nil{
                        callBack!((button.titleLabel?.text)!)
                    }
                
                }
                else{
                    (bu as! UIButton).backgroundColor = UIColor.white
                    (bu as! UIButton).isSelected = false
                }
            }
        }
        
    }
   
    
    func createScroller(images:[String],width:Int){
        
        scrollView?.subviews.forEach{$0.removeFromSuperview()}
        for i in 0..<images.count{
            let button = UIButton(frame: CGRect(x: i*width, y: 0, width: width,height: Int(self.frame.height) - 35))
            let label = UILabel()
            scrollView?.addSubview(button)
            scrollView?.addSubview(label)
            _ = label.sd_layout().topSpaceToView(button,0.5)?.bottomSpaceToView(scrollView,10)?.widthIs(CGFloat(width))?.heightIs(20)?.centerXEqualToView(button)
            
            label.text = images[i]
            label.font = UIFont(name: "Bobz Type", size: 10)
            label.textAlignment = .center
            label.textColor = UIColor.black
            button.backgroundColor  = UIColor.white
            button.setImage(UIImage(named:images[i]), for: .normal)
            button.addTarget(self, action: #selector(demo(button:)), for: .touchUpInside)
            button.titleLabel?.text = images[i]
            
            
        }
        
        scrollView?.height  = self.contentView.frame.height
        scrollView?.contentSize  = CGSize(width: images.count*width, height: Int(self.contentView.frame.height))
    
        
        
    }
    @objc  
    func demo(button:UIButton){
        print("image \(button.titleLabel?.text ?? "")")
        
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    


}

