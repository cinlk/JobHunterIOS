//
//  CommonJobDetailCellView.swift
//  internals
//
//  Created by ke.liang on 2018/4/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate let imgSize:CGSize = CGSize.init(width: 45, height: 40)

@objcMembers class CommonJobDetailCellView: UIView{

    
    // 控制 标签显示
    internal var showInternTag:Bool = false
    
    internal lazy var icon:UIImageView = {
        let image = UIImageView.init()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    
    internal lazy var company:UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.isAttributedContent = true
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20 )
        return label
        
    }()
    

    internal lazy var jobName:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = UIColor.black
        // 留出空白给标签
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 40)
        return label
    }()
    
    internal lazy var address:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    
    internal lazy var  degree:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    
    
    internal lazy var  create_time:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.blue
        label.textAlignment = .right
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    
    // 浏览次数
    internal lazy var checkNums:UILabel = {
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
            
            let url = URL.init(string: mode.icon)
            icon.kf.setImage(with: Source.network(url!), placeholder: #imageLiteral(resourceName: "default"), options: nil, progressBlock: nil, completionHandler: nil)
            //icon.image = UIImage.init(named: mode.icon)
            
            
            
            
            let paragrap = NSMutableParagraphStyle.init()
            
            paragrap.alignment = .center
            paragrap.lineBreakMode = .byWordWrapping
           
            let companyStr = NSMutableAttributedString.init(string: mode.company?.name ?? "", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.black,
                                                                                                
                                                                                                           
                                                                                                    NSAttributedString.Key.paragraphStyle: paragrap])
            
            
            if showInternTag && type == .intern{
 
                let attach = NSTextAttachment()
                let img = #imageLiteral(resourceName: "qqZone").changesize(size: CGSize.init(width: 17, height: 17), renderMode: .alwaysOriginal)
                attach.image = img

                attach.bounds = CGRect.init(x: 10, y: (UIFont.systemFont(ofSize: 16).capHeight - img.size.height)/2, width: img.size.width, height: img.size.height)
                let tagStr = NSAttributedString.init(attachment: attach)
                companyStr.append(tagStr)
            }
            
            company.attributedText = companyStr
            
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
        
        let views:[UIView] = [icon, jobName, company, address, degree, create_time, checkNums]
        
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
        _ = jobName.sd_layout().topSpaceToView(company,5)?.leftEqualToView(company)?.autoHeightRatio(0)
        _ = address.sd_layout().topSpaceToView(jobName,10)?.leftEqualToView(jobName)?.autoHeightRatio(0)
        _ = degree.sd_layout().topEqualToView(address)?.leftSpaceToView(address,5)?.autoHeightRatio(0)
        _ = checkNums.sd_layout().topEqualToView(icon)?.rightSpaceToView(self,15)?.autoHeightRatio(0)
        _ = create_time.sd_layout().topSpaceToView(checkNums,10)?.rightEqualToView(checkNums)?.autoHeightRatio(0)

        jobName.setMaxNumberOfLinesToShow(1)
        company.setMaxNumberOfLinesToShow(1)
        address.setMaxNumberOfLinesToShow(1)
        degree.setMaxNumberOfLinesToShow(1)
        create_time.setMaxNumberOfLinesToShow(1)
        checkNums.setMaxNumberOfLinesToShow(1)
    }
    
    
}
