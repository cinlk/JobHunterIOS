//
//  MainPageRecommandCell.swift
//  internals
//
//  Created by ke.liang on 2017/9/2.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import Kingfisher


fileprivate let lbName = "专栏推荐"
fileprivate let top = 5

class MainColumnistCell: BaseScrollerTableViewCell,UIScrollViewDelegate {

    
   private var itemViews:[UIView] = []

   private lazy var topView:UIView = { [unowned self] in
        let v = UIView()
        v.backgroundColor = UIColor.white
        let label = UILabel()
        label.text = lbName
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        v.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(v,10)?.centerYEqualToView(v)?.autoHeightRatio(0)
        return v
   }()
   
    private var topViewH:CGFloat = 25
    
    internal var selectedItem:((_ btn:UIButton)->Void)?
    // image url strings and title
//    internal var mode:[String:String]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.scrollView.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
       
         super.layoutSubviews()
        //scrollView.sd_resetLayout()
        //scrollView.sd_resetNewLayout()
        self.contentView.addSubview(topView)
        _ = topView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topEqualToView(self.contentView)?.heightIs(topViewH)
        
         _ = scrollView.sd_layout().leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.topSpaceToView(self.topView,5)?.bottomEqualToView(self.contentView)
        
         //super.layoutSubviews()
       
        
    }
    
    
    
    class func identity()->String{
        return "recommand"
    }
    
}

extension MainColumnistCell{
    
    internal func hiddenTitleView(){
        self.topView.isHidden = true
        self.topViewH = 0
    }
    
    @objc private func chooseItem(_ btn:UIButton){
        self.selectedItem?(btn)
    }
    
    internal  func setItems(width:CGFloat, items:[JobField]){
        
        itemViews.forEach{ $0.removeFromSuperview()}
        itemViews.removeAll()
        
        // height  只要小于 cell 的frame 高度就行
        scrollView.contentSize = CGSize.init(width: CGFloat(items.count)*(width+5) , height: self.height - topViewH - 5)
        
        for (idx, item) in items.enumerated(){
            
            
            let subView:UIView = UIView.init(frame: CGRect.zero)
            
            //_ = subView.sd_layout()?.bottomEqualToView(self.scrollView)?.topEqualToView(self.scrollView)
            subView.tag = idx
            
            let btn = UIButton.init(frame: CGRect.zero)
            
            btn.tag = idx
            btn.backgroundColor = UIColor.white
            if let url = URL.init(string: item.ImageUrl ?? ""){
                
                btn.kf.setImage(with: Source.network(url), for: .normal, placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
                btn.kf.setImage(with: Source.network(url), for: .highlighted, placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
           
            btn.titleLabel?.text = item.Title
            btn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            btn.addTarget(self, action: #selector(chooseItem(_:)), for: .touchUpInside)
            
            let subtitle = UILabel.init(frame: CGRect.zero)
            subtitle.text = item.Title
            subtitle.font = UIFont.systemFont(ofSize: 14)
            subtitle.textAlignment = .center
            subtitle.textColor = UIColor.black
            subView.sizeToFit()
            subView.addSubview(btn)
            subView.addSubview(subtitle)
            _ = btn.sd_layout().leftSpaceToView(subView,5)?.rightSpaceToView(subView,5)?.topSpaceToView(subView,5)?.heightRatioToView(subView, 0.7)
            _ = subtitle.sd_layout().topSpaceToView(btn,0)?.centerXEqualToView(btn)?.widthRatioToView(btn,1)?.heightRatioToView(subView, 0.2)
            
            itemViews.append(subView)
        }
        
        scrollView.sd_addSubviews(itemViews)
        itemViews.forEach { [unowned self] view in
            // cell 动态调整高度
            _ = view.sd_layout()?.bottomEqualToView(self.scrollView)?.topEqualToView(self.scrollView)?.xIs( CGFloat(view.tag) * (width + 5))?.yIs(0)?.widthIs(width)
        }
    }
    
    
}


extension MainColumnistCell{
    static func cellHeight()->CGFloat{
        return 80.0
    }
}


//extension MainColumnistCell{
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == self.scrollView{
//            if scrollView.contentOffset.y != 0 {
//                scrollView.contentOffset.y = 0
//            }
//        }
//    }
//}
