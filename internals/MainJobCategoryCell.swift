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

class MainJobCategoryCell: BaseScrollerTableViewCell,UIScrollViewDelegate{

    
    // image url strings and title
    override var mode:[String:String]?{
        didSet{
            scrollView.subviews.forEach{$0.removeFromSuperview()}
            guard let items = mode else {
                return
            }
            
            scrollView.contentSize = CGSize.init(width: CGFloat(items.count)*(itemWitdh+5) , height: scrollView.frame.height)
            var index = 0
            
            // MARK 设置btn 效果
            for (imageURL,title) in items{
               
                let btn = UIButton.init()
                btn.frame = CGRect(x: CGFloat(index)*(itemWitdh+5), y: 0, width: itemWitdh, height: cellHeightH - CGFloat(30))
                btn.tag = index
                btn.titleLabel?.text = title
                btn.backgroundColor = UIColor.white
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
                btn.titleLabel?.textAlignment = .center
                btn.setImage(UIImage.init(named: imageURL), for: .normal)
                btn.setImage(UIImage.init(named: imageURL), for: .highlighted)
                btn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
                btn.addTarget(self, action: #selector(chooseItem(_:)), for: .touchUpInside)
                let subtitle = UILabel.init(frame: CGRect.init(x: CGFloat(index)*(itemWitdh+5), y: cellHeightH - CGFloat(30) , width: itemWitdh, height: 25))
                
                subtitle.text = title
                subtitle.font = UIFont.systemFont(ofSize: 15)
                subtitle.textAlignment = .center
                subtitle.textColor = UIColor.black
                scrollView.addSubview(subtitle)
                
                scrollView.addSubview(btn)
                index += 1
            }
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.scrollView.delegate = self
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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


extension MainJobCategoryCell{
    
    @objc private func chooseItem(_ btn:UIButton){
        
       self.selectedItem?(btn)
    }
}
