//
//  MainPageRecommandCell.swift
//  internals
//
//  Created by ke.liang on 2017/9/2.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

fileprivate let cellHeightH:CGFloat = 120
fileprivate let itemWidth:CGFloat = ScreenW / 2 - 30

class MainPageRecommandCell: UITableViewCell,UIScrollViewDelegate {

   
   private lazy var scroller:UIScrollView = { [unowned self] in
        
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator =  false
        scroll.showsVerticalScrollIndicator = false
        scroll.bounces = true
        scroll.isPagingEnabled = false
        scroll.clipsToBounds = true
        scroll.delegate = self
        scroll.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        return scroll
    }()
    

    
    // call back
    var  chooseItem:((_ btn:UIButton)->Void)?
    
    
    var mode:[String:String]?{
        didSet{
            guard let items = mode  else {
                return
            }
            
            //stackview
            scroller.subviews.forEach{$0.removeFromSuperview()}
            scroller.contentSize = CGSize.init(width: CGFloat(items.count) * (itemWidth + 10), height: scroller.frame.height)
            var index = 0
            for (image,title) in items{
                
                
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: CGFloat(index)*(itemWidth+10), y: 0, width: itemWidth, height: scroller.frame.height)
                button.backgroundColor  = UIColor.clear
                //button.setImage(UIImage(named: image), for: .normal)
                button.setBackgroundImage(UIImage.init(named: image), for: .normal)
                button.setBackgroundImage(UIImage.init(named: image), for: .highlighted)

                button.imageView?.contentMode = .scaleToFill
                button.imageView?.clipsToBounds = true
                button.imageView?.alpha = 0.7
                button.titleLabel?.text = title
                button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
                button.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
                button.backgroundColor = UIColor.clear
                
                index += 1
                scroller.addSubview(button)
                
                
            }
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle  = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addSubview(scroller)
        
        _ = scroller.sd_layout().topEqualToView(self.contentView)?.leftEqualToView(self.contentView)?.bottomEqualToView(self.contentView)?.rightEqualToView(self.contentView)
        
    }
    
    
    class func cellHeight()->CGFloat {
        return cellHeightH
    }
    
    class func identity()->String{
        return "recommand"
    }
    
    
}

extension MainPageRecommandCell{
    @objc private func click(_ btn:UIButton){
        
        self.chooseItem?(btn)
    }
}
