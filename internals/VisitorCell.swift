//
//  visitorCell.swift
//  internals
//
//  Created by ke.liang on 2018/1/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import Kingfisher


fileprivate let iconSize:CGSize = CGSize.init(width: 55, height: 55)

@objcMembers class VisitorCell: UITableViewCell {

    
    private lazy var wrapperIcon:UIView = {
        let v = UIView.init()
        v.clipsToBounds = false
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    private lazy var avartar: UIImageView = {
        let img = UIImageView.init()
        img.clipsToBounds = false
        img.contentMode = .scaleToFill
        return img
        
    }()
    
    
    
    private lazy var hrName:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - iconSize.width)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        return label
        
    }()
    
    // YYYY-MM-DD
    private lazy var visite_time: UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - iconSize.width)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
        
    }()
    
    
    
    private lazy var company: UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - iconSize.width)
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var postion: UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(120)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    
    override var frame: CGRect{
        didSet{
            var newFrame = frame
            newFrame.origin.x += 10
            newFrame.size.width -= 20
            //newFrame.origin.y += 10
            newFrame.size.height -= 10
            super.frame = newFrame
        }
    }
    
    
   dynamic var mode:MyVisitors?{
        didSet{
            guard let mode = mode else {
                return
            }
            if let iconUrl = mode.userIcon {
                avartar.kf.setImage(with: Source.network(iconUrl), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            }
            if mode.checked == false {
                self.wrapperIcon.pp.addDot(color: UIColor.red)
                self.wrapperIcon.pp.moveBadge(x: -5, y: 5)
                self.wrapperIcon.pp.setBadge(height: 15)
                self.wrapperIcon.pp.setBadgeLabel { (l) in
                    l.text = "新"
                    l.size = CGSize.init(width: 15, height: 15)
                }
                
            }else{
                self.wrapperIcon.pp.hiddenBadge()
            }
            visite_time.text = mode.visitTimeStr
            hrName.text = mode.name
            company.text = mode.company
            postion.text = mode.title
            self.setupAutoHeight(withBottomViewsArray: [avartar, company], bottomMargin: 10)
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [wrapperIcon, visite_time, company, hrName, postion]
        self.contentView.sd_addSubviews(views)
        wrapperIcon.addSubview(avartar)
        _ = avartar.sd_layout()?.leftEqualToView(wrapperIcon)?.topEqualToView(wrapperIcon)?.bottomEqualToView(wrapperIcon)?.rightEqualToView(wrapperIcon)
        
        _ = wrapperIcon.sd_layout().leftSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.widthIs(iconSize.width)?.heightEqualToWidth()
        _ = hrName.sd_layout().leftSpaceToView(wrapperIcon,10)?.topSpaceToView(self.contentView,15)?.autoHeightRatio(0)
        
        _ = company.sd_layout().leftEqualToView(hrName)?.topSpaceToView(hrName,5)?.autoHeightRatio(0)
        _ = postion.sd_layout().leftSpaceToView(company,10)?.topEqualToView(company)?.autoHeightRatio(0)
        
        _ = visite_time.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(hrName)?.autoHeightRatio(0)
        
        avartar.sd_cornerRadiusFromHeightRatio = 0.5
        hrName.setMaxNumberOfLinesToShow(1)
        company.setMaxNumberOfLinesToShow(1)
        postion.setMaxNumberOfLinesToShow(1)
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "visitorCell"
    }
    

    
    
}
