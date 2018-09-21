//
//  JobDescription.swift
//  internals
//
//  Created by ke.liang on 2017/9/5.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit




@objcMembers  class JobDescription: UITableViewCell {

    private lazy var topdescription: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private lazy var works: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
         label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
        
    }()
    private lazy var workcontent: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 60)
        label.font = UIFont.systemFont(ofSize: 15)
        return label
        
    }()
    private lazy var demand: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
        
    }()
    private lazy var demandInfo: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 60)
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
        
    }()
    
    private lazy var line:UIView = {
        let line = UIView.init(frame: CGRect.zero)
         line.backgroundColor = UIColor.gray
        return line
    }()
    
    dynamic var mode:CompuseRecruiteJobs?{
        didSet{
            topdescription.text = "职位描述"
            works.text = "工作职责"
            workcontent.text = mode?.works
            demand.text = "任职资格"
            demandInfo.text = mode?.requirement
            self.setupAutoHeight(withBottomView: demandInfo, bottomMargin: 10)
            
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let views:[UIView] = [line, topdescription, workcontent, works, demand, demandInfo]
        self.contentView.sd_addSubviews(views)
        
        _ = topdescription.sd_layout().leftSpaceToView(self.contentView,20)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = line.sd_layout().topSpaceToView(topdescription,5)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.heightIs(1)
        _ = works.sd_layout().topSpaceToView(line,10)?.leftEqualToView(topdescription)?.autoHeightRatio(0)
        _ = workcontent.sd_layout().leftEqualToView(works)?.topSpaceToView(works,10)?.autoHeightRatio(0)
        
        _ = demand.sd_layout().topSpaceToView(workcontent,20)?.leftEqualToView(workcontent)?.autoHeightRatio(0)
        _ = demandInfo.sd_layout().topSpaceToView(demand,10)?.leftEqualToView(demand)?.autoHeightRatio(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "JobDescription"
    }
    
}
