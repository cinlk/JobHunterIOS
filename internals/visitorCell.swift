//
//  visitorCell.swift
//  internals
//
//  Created by ke.liang on 2018/1/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let iconSize:CGSize = CGSize.init(width: 45, height: 45)

@objcMembers class visitorCell: UITableViewCell {

    private lazy var avartar: UIImageView = {
        let img = UIImageView.init()
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        return img
        
    }()
    
    private lazy var titleName:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        return label
        
    }()
    
    // YYYY-MM-DD
    private lazy var visite_time: UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        return label
        
    }()
    
    private lazy var company: UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - iconSize.width)
        label.textAlignment = .left
        label.textColor = UIColor.black
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
    
    
   
   dynamic var mode:HRVisitorModel?{
        didSet{
            guard let mode = mode else {
                return
            }
            avartar.image = UIImage.init(named: mode.icon)
            visite_time.text = mode.visitTimeStr
            titleName.text = mode.name! + "看过你"
            company.text = mode.company
            
            self.setupAutoHeight(withBottomViewsArray: [avartar, company], bottomMargin: 10)
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [avartar, visite_time, company, titleName ]
        self.contentView.sd_addSubviews(views)
        
        _ = avartar.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(iconSize.width)?.heightEqualToWidth()
        _ = titleName.sd_layout().leftSpaceToView(avartar,10)?.topEqualToView(avartar)?.autoHeightRatio(0)
        
        _ = company.sd_layout().leftEqualToView(titleName)?.topSpaceToView(titleName,10)?.autoHeightRatio(0)
        
        _ = visite_time.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(titleName)?.autoHeightRatio(0)
        
        avartar.sd_cornerRadiusFromHeightRatio = 0.5
        titleName.setMaxNumberOfLinesToShow(1)
        company.setMaxNumberOfLinesToShow(1)
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "visitorCell"
    }
    

    
    
}
