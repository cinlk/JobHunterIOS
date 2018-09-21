//
//  JobMessageCell.swift
//  internals
//
//  Created by ke.liang on 2018/1/14.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let desText:String = "你刚刚投递了这个职位"
fileprivate let iconSize:CGSize = CGSize.init(width: 45, height: 45)

@objcMembers class JobMessageCell: UITableViewCell {

    
    private lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
    private lazy var jobName: UILabel = {
        let jobName = UILabel()
        jobName.setSingleLineAutoResizeWithMaxWidth(ScreenW - 45 - 30)
        jobName.textAlignment = .left
        jobName.font = UIFont.systemFont(ofSize: 18)
        return jobName
    }()
    
    private lazy var company: UILabel = {
        let companyLabel = UILabel()
        companyLabel.setSingleLineAutoResizeWithMaxWidth(ScreenW - 45 - 30)
        companyLabel.textAlignment = .left
        companyLabel.font = UIFont.systemFont(ofSize: 14)
        return companyLabel
    }()
    
    private lazy var tags: UILabel = {
        let tags = UILabel()
        tags.setSingleLineAutoResizeWithMaxWidth(ScreenW - 45 - 30)
        tags.textAlignment = .left
        tags.font = UIFont.systemFont(ofSize: 14)
        return tags
        
    }()
    
    
    
    private lazy var salary: UILabel = {
        let salary = UILabel()
        salary.setSingleLineAutoResizeWithMaxWidth(ScreenW - 45 - 30)
        salary.textAlignment = .center
        salary.font = UIFont.systemFont(ofSize: 14)
        return salary
    }()
    
    
    private lazy var desTilte:UILabel = {
        let lb = UILabel.init(frame: CGRect.zero)
        lb.backgroundColor = UIColor.clear
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = UIColor.black
        lb.setSingleLineAutoResizeWithMaxWidth(180)
        lb.textAlignment = .center
        lb.text = desText
        return lb
    }()
    
    // 标题view
    private lazy var titleBackV:UIView = {
        let tbv = UIView.init(frame: CGRect.zero)
        tbv.backgroundColor = UIColor.init(r: 190.0, g: 190.0, b: 190.0)
        tbv.layer.cornerRadius = 4
        tbv.layer.masksToBounds = true
        return tbv
        
    }()
    
    //  内容背景view
    private lazy var container:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    
    
    // 重写frame
    override var frame: CGRect{
        didSet{
            var newFrame = frame
            newFrame.origin.x += 10
            newFrame.size.width -= 20
            newFrame.size.height -= 10
            super.frame = newFrame
        }
    }
    
   dynamic  var mode:JobDescriptionlMessage?{
        didSet{
        
            guard let mode = mode else {
                
                return
            }
            
            self.icon.image = UIImage.init(named: mode.icon)
            self.company.text = mode.company
            self.jobName.text = mode.jobName
            self.tags.text = mode.tags.joined(separator: " ")
            self.salary.text = mode.salary
            self.setupAutoHeight(withBottomView: self.tags, bottomMargin: 20)
       
           
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        let views:[UIView] =  [container, icon, jobName, company, tags, salary, titleBackV]
        
        self.contentView.sd_addSubviews(views)
        self.titleBackV.addSubview(desTilte)
        
        
        
        _ = self.titleBackV.sd_layout().topSpaceToView(self.contentView,5)?.centerXEqualToView(self.contentView)?.widthIs(desTilte.width + 10)?.heightIs(desTilte.height + 10)
        _ = self.desTilte.sd_layout().centerXEqualToView(titleBackV)?.centerYEqualToView(titleBackV)?.autoHeightRatio(0)
        
         _  = self.container.sd_layout().topSpaceToView(self.titleBackV,5)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.bottomEqualToView(self.contentView)
        
        
        _ = self.icon.sd_layout().topSpaceToView(self.titleBackV,10)?.leftSpaceToView (self.contentView,5)?.widthIs(iconSize.width)?.autoHeightRatio(1)
        
        _ = self.jobName.sd_layout().topEqualToView(icon)?.leftSpaceToView(icon,5)?.autoHeightRatio(0)
        _ = self.company.sd_layout().leftEqualToView(jobName)?.topSpaceToView(jobName,5)?.autoHeightRatio(0)
        _ = self.tags.sd_layout().leftEqualToView(company)?.topSpaceToView(company,5)?.autoHeightRatio(0)
        _ = self.salary.sd_layout().topEqualToView(icon)?.rightSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identitiy()->String{
        return "jobMessageCard"
    }
    
    
}
