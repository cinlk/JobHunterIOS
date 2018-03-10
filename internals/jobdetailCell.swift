//
//  jobdetailCell.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate let imgSize:CGSize = CGSize.init(width: 45, height: 40)

@objcMembers class jobdetailCell: UITableViewCell {
    
   
    lazy var icon:UIImageView = {
        let image = UIImageView.init()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.backgroundColor = UIColor.clear
        return image
    }()
    
    lazy var JobName:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    lazy var company:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20 )
        return label
        
    }()
    
    lazy var address:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    lazy var type:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    lazy var  degree:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    lazy var  internDay:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    
    lazy var  create_time:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.sizeToFit()
        label.textAlignment = .right
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    lazy var  salary:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.red
        label.sizeToFit()
        label.textAlignment = .right
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    
    
    //
    lazy var rightArrow:UIImageView = {
        let right = UIImageView.init(image: #imageLiteral(resourceName: "rightforward") )
        right.clipsToBounds = true
        right.contentMode  = .scaleAspectFit
        return right
        
    }()
    
    dynamic var mode:CompuseRecruiteJobs?{
        didSet{
            icon.image = UIImage.init(named: (mode?.picture)!)
            JobName.text = mode?.jobName
            company.text = mode?.company
            address.text = mode?.address
            type.text = "校招"
            degree.text = mode?.education
            internDay.text = "0"
            salary.text = mode?.salary
            create_time.text = mode?.create_time
            setLayout()
            self.setupAutoHeight(withBottomViewsArray: [address, type, degree], bottomMargin: 10)
            
        }
    }

    private var deliver:Bool = false
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.deliver = false
        let views:[UIView] = [icon, JobName, company, address, type, degree, internDay, create_time, salary,rightArrow]
        self.contentView.sd_addSubviews(views)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func identity()->String{
        return "compuseJobs"
    }
    
    // MARK 区分cell 投递 和非投递
    private func setLayout(){
        
        
        _ = icon.sd_layout().topSpaceToView(self.contentView,5)?.leftSpaceToView(self.contentView,5)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
        _ = JobName.sd_layout().topEqualToView(icon)?.leftSpaceToView(icon,10)?.autoHeightRatio(0)
        _ = company.sd_layout().leftEqualToView(JobName)?.topSpaceToView(JobName,3)?.autoHeightRatio(0)
        _ = address.sd_layout().leftEqualToView(JobName)?.topSpaceToView(company,5)?.autoHeightRatio(0)
        _ = type.sd_layout().topEqualToView(address)?.leftSpaceToView(address,5)?.autoHeightRatio(0)
        _ = degree.sd_layout().topEqualToView(type)?.leftSpaceToView(type,5)?.autoHeightRatio(0)
        _ = internDay.sd_layout().topEqualToView(degree)?.leftSpaceToView(degree,5)?.autoHeightRatio(0)
        _ = salary.sd_layout().topSpaceToView(self.contentView,20)?.rightSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = create_time.sd_layout().rightEqualToView(salary)?.topSpaceToView(salary,10)?.autoHeightRatio(0)
        
        
        if deliver{
            _ = rightArrow.sd_layout().rightEqualToView(salary)?.centerYEqualToView(self.contentView)?.widthIs(20)?.heightIs(20)
        }else{
            rightArrow.frame = CGRect.zero
        }
        
        JobName.setMaxNumberOfLinesToShow(1)
        company.setMaxNumberOfLinesToShow(1)
        address.setMaxNumberOfLinesToShow(1)
        type.setMaxNumberOfLinesToShow(1)
        degree.setMaxNumberOfLinesToShow(1)
        internDay.setMaxNumberOfLinesToShow(1)
        salary.setMaxNumberOfLinesToShow(1)
        create_time.setMaxNumberOfLinesToShow(1)
    }
    
    
    class func cellHeight()->CGFloat{
        return  65
    }

}
