//
//  MainPageRecommandCell.swift
//  internals
//
//  Created by ke.liang on 2017/9/2.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

fileprivate let cellHeightH:CGFloat = 140
fileprivate let itemWidth:CGFloat = ScreenW / 3 - 20

class MainColumnistCell: BaseScrollerTableViewCell,UIScrollViewDelegate {


   private lazy var topView:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        let label = UILabel()
        label.text = "专栏推荐"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        v.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(v,10)?.centerYEqualToView(v)?.autoHeightRatio(0)
        return v

   }()
    
    
   override  var mode:[String:String]?{
        didSet{
            guard let items = mode  else {
                return
            }
            
            //stackview
            scrollView.subviews.forEach{$0.removeFromSuperview()}
            scrollView.contentSize = CGSize.init(width: CGFloat(items.count) * (itemWidth + 10), height: scrollView.frame.height)
            var index = 0
            for (image,title) in items{
                
                
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: CGFloat(index)*(itemWidth+10), y: 0, width: itemWidth, height: scrollView.frame.height - 20)
                button.backgroundColor  = UIColor.clear
                //button.setImage(UIImage(named: image), for: .normal)
                //button.setBackgroundImage(UIImage.init(named: image), for: .normal)
                //button.setBackgroundImage(UIImage.init(named: image), for: .highlighted)
                button.setImage(UIImage.init(named: image), for: .normal)
                button.setImage(UIImage.init(named: image), for: .highlighted)
                button.imageView?.contentMode = .scaleToFill
                button.imageView?.clipsToBounds = true
                button.imageView?.alpha = 0.7
                button.titleLabel?.text = title
                button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
                button.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
                button.backgroundColor = UIColor.clear
                let label = UILabel.init(frame: CGRect.init(x: CGFloat(index)*(itemWidth+10), y: scrollView.frame.height - 20, width: itemWidth, height: 20))
                // TEST 名字
                label.text = "专栏\(index)"
                //label.setSingleLineAutoResizeWithMaxWidth(itemWidth)
                label.textAlignment = .center
                index += 1
                scrollView.addSubview(label)
                scrollView.addSubview(button)
                
                
            }
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.sd_resetLayout()
        
        self.contentView.addSubview(topView)
        _ = topView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topEqualToView(self.contentView)?.heightIs(25)
        
         _ = scrollView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(self.topView,5)?.bottomEqualToView(self.contentView)
       
        
    }
    
    
    class func cellHeight()->CGFloat {
        return cellHeightH
    }
    
    class func identity()->String{
        return "recommand"
    }
    
}

extension MainColumnistCell{
    @objc private func click(_ btn:UIButton){
        
        self.selectedItem?(btn)
    }
}
