//
//  CommonJobDetailCellView.swift
//  internals
//
//  Created by ke.liang on 2018/4/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let imgSize:CGSize = CGSize.init(width: 45, height: 40)

@objcMembers class CommonJobDetailCellView: UIView{

    
    // 控制 标签显示
    internal var showTag:Bool = true
    
    private lazy var icon:UIImageView = {
        let image = UIImageView.init()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    
    private lazy var company:UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20 )
        return label
        
    }()
    
    private lazy var interTag:UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.orange
        label.text = "实习"
        label.isHidden = true
        return label
        
    }()
    private lazy var jobName:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = UIColor.black
        // 留出空白给标签
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 40)
        return label
    }()
    
    private lazy var address:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    
    private lazy var  degree:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    
    
    private lazy var  create_time:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.blue
        label.textAlignment = .right
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    
    // 浏览次数
    private lazy var checkNums:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
        
    }()
    
    
    
    dynamic var mode:CompuseRecruiteJobs?{
        didSet{
            
            guard  let mode = mode, let type = mode.kind else {
                return
            }
            
            icon.image = UIImage.init(named: mode.icon)
            
            
            if showTag{
                interTag.isHidden  = type == .intern ? false : true
            }
            
            
            company.text = mode.companyID

            jobName.text = mode.name
            
            address.text = mode.addressStr
            
            degree.text = "| " + mode.education
           
            create_time.text = mode.creatTimeStr
            
            checkNums.text = "\(mode.readNums)人浏览"
            
       
           
            self.setupAutoHeight(withBottomViewsArray: [address, degree], bottomMargin: 5)
            
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let views:[UIView] = [icon, jobName, company, address, degree, create_time, checkNums,interTag]
        
        self.sd_addSubviews(views)
        setLayout()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
}


extension  CommonJobDetailCellView{
    
    private func setLayout(){
        
        
        _ = icon.sd_layout().topSpaceToView(self,5)?.leftSpaceToView(self,5)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
       
        
        _ = company.sd_layout().topEqualToView(icon)?.leftSpaceToView(icon,15)?.autoHeightRatio(0)
        _ = interTag.sd_layout().leftSpaceToView(company,5)?.centerYEqualToView(company)?.autoHeightRatio(0)?.widthIs(28)
        _ = jobName.sd_layout().topSpaceToView(company,5)?.leftEqualToView(company)?.autoHeightRatio(0)
        _ = address.sd_layout().topSpaceToView(jobName,10)?.leftEqualToView(jobName)?.autoHeightRatio(0)
        _ = degree.sd_layout().topEqualToView(address)?.leftSpaceToView(address,5)?.autoHeightRatio(0)
        _ = checkNums.sd_layout().topEqualToView(icon)?.rightSpaceToView(self,15)?.autoHeightRatio(0)
        _ = create_time.sd_layout().topSpaceToView(checkNums,10)?.rightEqualToView(checkNums)?.autoHeightRatio(0)

        interTag.setMaxNumberOfLinesToShow(1)
        jobName.setMaxNumberOfLinesToShow(1)
        company.setMaxNumberOfLinesToShow(1)
        address.setMaxNumberOfLinesToShow(1)
        degree.setMaxNumberOfLinesToShow(1)
        create_time.setMaxNumberOfLinesToShow(1)
        checkNums.setMaxNumberOfLinesToShow(1)
    }
    
    
}
