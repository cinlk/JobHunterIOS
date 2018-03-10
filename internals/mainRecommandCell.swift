//
//  MainPageRecommandCell.swift
//  internals
//
//  Created by ke.liang on 2017/9/2.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

fileprivate let cellHeightH:CGFloat = 120
fileprivate let itemWidth:CGFloat = ScreenW / 4

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
    
    private lazy var line:UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private lazy  var topView:UIView = {
        
        var uiview = UIView.init(frame: CGRect.zero)
        var label:UILabel  = UILabel()
        label.text = "热门推荐"
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        //label.font = UIFont(name: "Bobz Type", size: 5)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor  =  0.5
        label.font = UIFont.systemFont(ofSize: 12)
        uiview.addSubview(label)
        
        let right = UIImageView.init(image: #imageLiteral(resourceName: "rightforward"))
        right.clipsToBounds = true
        uiview.addSubview(right)
        
        _ = label.sd_layout().leftSpaceToView(uiview,10)?.topSpaceToView(uiview,2.5)?.autoHeightRatio(0)
        _ = right.sd_layout().rightSpaceToView(uiview,10)?.topEqualToView(label)?.widthIs(15)?.autoHeightRatio(3/2)
        return uiview
        
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
            scroller.contentSize = CGSize.init(width: CGFloat(items.count) * (itemWidth + 5), height: scroller.frame.height)
            var index = 0
            for (image,title) in items{
                
                
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: CGFloat(index)*(itemWidth+5), y: 0, width: itemWidth, height: scroller.frame.height)
                button.backgroundColor  = UIColor.clear
                button.setImage(UIImage(named: image), for: .normal)
                
                button.imageView?.contentMode = .scaleAspectFill
                button.imageView?.clipsToBounds = true
                button.imageView?.alpha = 0.7
                button.setTitle(title, for: .normal)
                button.setTitleColor(UIColor.black, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                button.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
                
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
        self.contentView.addSubview(topView)
        self.contentView.addSubview(line)
        self.contentView.addSubview(scroller)
        
        _ = topView.sd_layout().topEqualToView(self.contentView)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.heightIs(25)
        
        _ = line.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(topView,1)?.heightIs(1)
        _ = scroller.sd_layout().topSpaceToView(line,0)?.leftEqualToView(self.contentView)?.bottomEqualToView(self.contentView)?.rightEqualToView(self.contentView)
        
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
