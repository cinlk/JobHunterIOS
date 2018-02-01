//
//  JobMessageCell.swift
//  internals
//
//  Created by ke.liang on 2018/1/14.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let desText:String = "你刚刚投递了这个职位"

class JobMessageCell: UITableViewCell {

    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var jobName: UILabel!
    
    @IBOutlet weak var company: UILabel!
    
    @IBOutlet weak var tags: UILabel!
    
    @IBOutlet weak var salary: UILabel!
    
    private lazy var desTilte:UILabel = {
        let lb = UILabel.init(frame: CGRect.zero)
        lb.backgroundColor = UIColor.clear
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = UIColor.black
        lb.text = desText
        return lb
    }()
    
    private lazy var titleBackV:UIView = {
        let tbv = UIView.init(frame: CGRect.zero)
        tbv.backgroundColor = UIColor.init(r: 190.0, g: 190.0, b: 190.0)
        tbv.layer.cornerRadius = 4
        tbv.layer.masksToBounds = true
        return tbv
        
    }()
    
    private lazy var infoV:UIView = {
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.white
        return v
    }()
    
    
    // 重写frame
    override var frame: CGRect{
        didSet{
            var newFrame = frame
            newFrame.origin.x += 10
            newFrame.size.width -= 20
            //newFrame.origin.y +=
            newFrame.size.height -= 10
            super.frame = newFrame
        }
    }
    
    var info:(icon:String,jobName:String, company:String, tags:String, salary:String)? {
        
        didSet{
            self.icon.image = UIImage.init(named: info!.icon)
            self.company.text = info!.company
            self.jobName.text = info!.jobName
            self.tags.text = info!.tags
            self.salary.text = info!.salary
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.insertSubview(infoV, at: 0)
        self.contentView.addSubview(titleBackV)
        self.titleBackV.addSubview(desTilte)
        self.desTilte.sizeToFit()
//        self.infoV.addSubview(icon)
//        self.infoV.addSubview(jobName)
//        self.infoV.addSubview(company)
//        self.infoV.addSubview(tags)
//        self.infoV.addSubview(salary)
        
    }
    
    override func layoutSubviews() {
        
        
        _ = self.titleBackV.sd_layout().topSpaceToView(self.contentView,5)?.centerXEqualToView(self.contentView)?.widthIs(desTilte.width + 10)?.heightIs(desTilte.height + 10)
        _ = self.desTilte.sd_layout().centerXEqualToView(titleBackV)?.centerYEqualToView(titleBackV)?.widthIs(desTilte.width)?.heightIs(desTilte.height)
        
        _  = self.infoV.sd_layout().topSpaceToView(self.titleBackV,2)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.bottomEqualToView(self.contentView)
        
        
        _ = self.icon.sd_layout().topSpaceToView(self.titleBackV,5)?.leftEqualToView(self.contentView)?.widthIs(40)?.heightIs(30)
        _ = self.jobName.sd_layout().topEqualToView(icon)?.leftSpaceToView(icon,5)?.widthIs(200)?.heightIs(20)
        _ = self.company.sd_layout().leftEqualToView(jobName)?.topSpaceToView(jobName,2.5)?.widthIs(120)?.heightIs(15)
        _ = self.tags.sd_layout().leftEqualToView(company)?.topSpaceToView(company,2.5)?.widthIs(200)?.heightIs(15)
        _ = salary.sd_layout().topEqualToView(icon)?.rightSpaceToView(self.contentView,5)?.widthIs(100)?.heightIs(15)
        
    
    }
    
    
    class func identitiy()->String{
        return "jobMessageCard"
    }
    
    class func cellHeight()->CGFloat{
        return 120.0
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
