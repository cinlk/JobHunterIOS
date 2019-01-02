//
//  MainPageRecommandCell.swift
//  internals
//
//  Created by ke.liang on 2017/9/2.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import Kingfisher


class MainColumnistCell: BaseScrollerTableViewCell,UIScrollViewDelegate {

    
   private var itemViews:[UIView] = []

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
   
    internal var topViewH:CGFloat = 25{
        willSet{
            self.topView.isHidden = newValue == 0 ? true : false
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.scrollView.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.sd_resetLayout()
        
        self.contentView.addSubview(topView)
        _ = topView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topEqualToView(self.contentView)?.heightIs(topViewH)
        
         _ = scrollView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(self.topView,5)?.bottomEqualToView(self.contentView)
       
        
    }
    

    
    class func identity()->String{
        return "recommand"
    }
    
}

extension MainColumnistCell{
    @objc private func chooseItem(_ btn:UIButton){
        self.selectedItem?(btn)
    }
    
    internal  func setItems(width:CGFloat, height:CGFloat, items:[String:String]){
        
        itemViews.removeAll()
        scrollView.subviews.forEach{$0.removeFromSuperview()}
       
        scrollView.contentSize = CGSize.init(width: CGFloat(items.count)*(width+5) , height: height - topViewH)
        
        for (idx, item) in items.enumerated(){
            
            
            let subView:UIView = UIView.init(frame: CGRect.init(x: CGFloat(idx)*(width+5), y: 0, width: width, height: height - topViewH))
            
            let btn = UIButton.init(frame: CGRect.zero)
            
            btn.tag = idx
            btn.backgroundColor = UIColor.white
            let url = URL.init(string: item.key)
            btn.kf.setImage(with: Source.network(url!), for: .normal, placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            btn.kf.setImage(with: Source.network(url!), for: .highlighted, placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
           
            btn.titleLabel?.text = item.value
            btn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            btn.addTarget(self, action: #selector(chooseItem(_:)), for: .touchUpInside)
            
            let subtitle = UILabel.init(frame: CGRect.zero)
            subtitle.text = item.value
            subtitle.font = UIFont.systemFont(ofSize: 15)
            subtitle.textAlignment = .center
            subtitle.textColor = UIColor.black
            
            subView.addSubview(btn)
            subView.addSubview(subtitle)
            _ = btn.sd_layout().leftSpaceToView(subView,5)?.rightSpaceToView(subView,5)?.topSpaceToView(subView,5)?.heightIs(height - topViewH - CGFloat(30))
            _ = subtitle.sd_layout().topSpaceToView(btn,0)?.centerXEqualToView(btn)?.bottomSpaceToView(subView,5)?.widthRatioToView(btn,1)
            itemViews.append(subView)
        }
        
        scrollView.sd_addSubviews(itemViews)
        
    }
    
    
}

extension MainColumnistCell{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView{
            if scrollView.contentOffset.y != 0 {
                scrollView.contentOffset.y = 0
            }
        }
    }
}
