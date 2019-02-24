//
//  NearMeetingsTableViewCell.swift
//  internals
//
//  Created by ke.liang on 2019/2/14.
//  Copyright © 2019 lk. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate let imgSize:CGSize = CGSize.init(width: 80, height: 80)

@objcMembers class NearMeetingsTableViewCell: UITableViewCell {

   
    dynamic var mode:NearByTalkMeetingModel?{
        didSet{
            guard  let mode = mode  else {
                return
            }
            if  let url = mode.collegeIconURL  {
                self.collegeIcon.kf.setImage(with: Source.network(url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            }
            self.collegeName.text = mode.college
            self.simplifyAddress.text = mode.address
            self.startTime.text = mode.startTimeStr
            self.distance.text = "\(mode.distance)"
            
            self.setupAutoHeight(withBottomViewsArray: [self.simplifyAddress,self.collegeIcon], bottomMargin: 10)
            
            
        }
    }
    
    private lazy var collegeIcon:UIImageView = {
        let im = UIImageView.init(frame: CGRect.zero)
        im.contentMode = .scaleAspectFit
        im.clipsToBounds = true
        return im
    }()
    
    private lazy var collegeName:UILabel = {
        let lb = UILabel.init(frame: CGRect.zero)
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 100)
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = UIColor.black
        return lb
    }()
    
    private lazy var simplifyAddress:UILabel = {
        let lb = UILabel.init(frame: CGRect.zero)
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 100)
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = UIColor.black
        return lb
    }()
    
    private lazy var startTime:UILabel = {
        let lb = UILabel.init(frame: CGRect.zero)
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 100)
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = UIColor.black
        return lb
    }()
    
    
    private lazy var distance:UILabel = {
        let lb = UILabel.init(frame: CGRect.zero)
        lb.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 100)
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = UIColor.black
        return lb
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        
        let views:[UIView]  = [collegeIcon, collegeName, simplifyAddress, startTime, distance]
        self.contentView.sd_addSubviews(views)
        _ = collegeIcon.sd_layout()?.leftSpaceToView(self.contentView, 10)?.topSpaceToView(self.contentView, 10)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
        _ = collegeName.sd_layout()?.leftSpaceToView(self.collegeIcon,10)?.topEqualToView(self.collegeIcon)?.autoHeightRatio(0)
        _ = simplifyAddress.sd_layout()?.topSpaceToView(self.collegeName, 10)?.leftEqualToView(self.collegeName)?.autoHeightRatio(0)
        _ = startTime.sd_layout()?.rightSpaceToView(self.contentView, 10)?.topEqualToView(self.collegeIcon)?.autoHeightRatio(0)
        _ = distance.sd_layout()?.topSpaceToView(self.startTime, 10)?.rightEqualToView(self.startTime)?.autoHeightRatio(0)
        
        
        collegeName.setMaxNumberOfLinesToShow(2)
        simplifyAddress.setMaxNumberOfLinesToShow(1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
   

}


extension NearMeetingsTableViewCell {
    class  func identify()->String {
        return "nearMeetingsTableViewCell"
    }
}
