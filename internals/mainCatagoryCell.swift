//
//  MainPageCatagoryCell
//  internals
//
//  Created by ke.liang on 2017/9/2.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

fileprivate let cellHeightH:CGFloat = 80
fileprivate let itemWitdh:CGFloat = ScreenW / 4


class MainPageCatagoryCell: UITableViewCell,UIScrollViewDelegate{

    
    
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView.init(frame: self.contentView.frame)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        scrollView.bounces = true
        scrollView.isPagingEnabled = false
        scrollView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        //scrollView?.height = self.frame.height
        scrollView.canCancelContentTouches  = true
        return scrollView
        
    }()
    
    private var event:UIGestureRecognizer?
    
    var chooseItem:((_ btn:UIButton)->Void)?
    
    
    private var itemBtn:[UIButton] = []
    
    // image url strings and title
    var mode:[String:String]?{
        didSet{
            scrollView.subviews.forEach{$0.removeFromSuperview()}
            guard let items = mode else {
                return
            }
            itemBtn.removeAll()
            
            scrollView.contentSize = CGSize.init(width: CGFloat(items.count)*(itemWitdh+5) , height: scrollView.frame.height)
            var index = 0
            
            // MARK 设置btn 效果
            for (imageURL,title) in items{
               
                let btn = UIButton.init()
                btn.frame = CGRect(x: CGFloat(index)*(itemWitdh+5), y: 10, width: itemWitdh, height: cellHeightH - CGFloat(10))
                
                btn.backgroundColor = UIColor.white
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
                btn.titleLabel?.textAlignment = .center
                
                //tagButton.tag = 100 + i
                btn.setTitle(title, for: .normal)
                btn.setTitleColor(UIColor.black, for: .normal)
                //let img =
                btn.setImage(UIImage.init(named: imageURL), for: .normal)
            
                //tagButton.addTarget(self, action: #selector(tag(button:)), for: .touchUpInside)
                btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0)
                btn.addTarget(self, action: #selector(chooseItem(_:)), for: .touchUpInside)
                scrollView.addSubview(btn)
                itemBtn.append(btn)
                index += 1
            }
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(scrollView)
        _ = scrollView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topEqualToView(self.contentView)?.bottomEqualToView(self.contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    class func cellHeight()->CGFloat{
        return cellHeightH
    }

    class func identity()->String{
        return "catagory"
    }
}


extension MainPageCatagoryCell{
    
    @objc private func chooseItem(_ btn:UIButton){
       self.chooseItem?(btn)
    }
}
