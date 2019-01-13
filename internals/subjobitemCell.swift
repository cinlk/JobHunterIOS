//
//  subjobitem.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit




fileprivate let iconSize:CGSize = CGSize.init(width: 20, height: 18)


internal class baseSubScribleCell:UITableViewCell{
    
    
    lazy var locate: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.setSingleLineAutoResizeWithMaxWidth(200)
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    lazy var salary: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.setSingleLineAutoResizeWithMaxWidth(200)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    
    lazy var business: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    
    
    lazy var degree: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.setSingleLineAutoResizeWithMaxWidth(200)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    override var frame: CGRect{
        didSet{
            var newFrame = frame
            newFrame.size.height -= 10
            super.frame = newFrame
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let views:[UIView] = [locate, salary, business, degree]
        self.contentView.sd_addSubviews(views)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}


@objcMembers class subScribeInternCell: baseSubScribleCell{
    
    private lazy var internMonth: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    
    
    private lazy var internDay: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    dynamic var mode:internSubscribeModel?{
        didSet{
            
            guard let mode = mode  else {
                return
            }
            
            self.internMonth.text = mode.internMonth
            self.internDay.text = mode.internDay
            self.locate.text = mode.locate
            self.degree.text = mode.degree
            self.salary.text = mode.internSalary
            self.business.text = mode.business
            
            
            self.setupAutoHeight(withBottomViewsArray: [internMonth,internDay], bottomMargin: 20)
            
            
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [internMonth, internDay]
        self.contentView.sd_addSubviews(views)
        
        _ = business.sd_layout().topSpaceToView(self.contentView,10)?.leftSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        
        _ = locate.sd_layout().leftEqualToView(business)?.topSpaceToView(business,10)?.autoHeightRatio(0)
        
        _ = degree.sd_layout().leftSpaceToView(locate,15)?.centerYEqualToView(locate)?.autoHeightRatio(0)
        
        _ = salary.sd_layout().leftSpaceToView(degree,15)?.centerYEqualToView(degree)?.autoHeightRatio(0)
        
        _ = internDay.sd_layout().leftEqualToView(locate)?.topSpaceToView(locate,10)?.autoHeightRatio(0)
        _ = internMonth.sd_layout().leftSpaceToView(internDay,15)?.centerYEqualToView(internDay)?.autoHeightRatio(0)
        
        
        
        business.setMaxNumberOfLinesToShow(2)
        locate.setMaxNumberOfLinesToShow(1)
        degree.setMaxNumberOfLinesToShow(1)
        salary.setMaxNumberOfLinesToShow(1)
        internDay.setMaxNumberOfLinesToShow(1)
        internMonth.setMaxNumberOfLinesToShow(1)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    static  func identity()->String{
        return "subScribeInternCell"
    }
}

@objcMembers class subScribeGraduateCell: baseSubScribleCell {

    

    
    dynamic var mode:graduateSubscribeModel?{
        didSet{
            
            guard  let mode = mode  else {
                return
            }
            
            self.locate.text = mode.locate
            self.degree.text = mode.degree
            self.salary.text = mode.salary
            self.business.text = mode.business
            self.setupAutoHeight(withBottomViewsArray: [locate,salary,business], bottomMargin: 20)
            
        
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _ = business.sd_layout().topSpaceToView(self.contentView,10)?.leftSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        
        _ = locate.sd_layout().leftEqualToView(business)?.topSpaceToView(business,10)?.autoHeightRatio(0)
        
        _ = degree.sd_layout().leftSpaceToView(locate,15)?.centerYEqualToView(locate)?.autoHeightRatio(0)
        
        _ = salary.sd_layout().leftSpaceToView(degree,15)?.centerYEqualToView(degree)?.autoHeightRatio(0)
        
        
        business.setMaxNumberOfLinesToShow(2)
        locate.setMaxNumberOfLinesToShow(1)
        degree.setMaxNumberOfLinesToShow(1)
        salary.setMaxNumberOfLinesToShow(1)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    static  func identity()->String{
        return "subScribeGraduateCell"
    }
    

    
}



