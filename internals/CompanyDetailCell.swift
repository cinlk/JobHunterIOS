//
//  CompanyDetailCell.swift
//  internals
//
//  Created by ke.liang on 2017/9/9.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

fileprivate let titleStr:String = "公司资料"
fileprivate let addressStr:String = "公司地址:"
fileprivate let website:String = "公司网址:"

@objcMembers class CompanyDetailCell: UITableViewCell {

    private lazy var title: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = titleStr
        return label
    }()
    private lazy var address: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = addressStr
        return label
    }()
    private lazy var adressDetail: UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    // 网址链接
    private lazy var webAddress:UILabel = { [unowned self] in
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = website
        
        return label
    }()
    
    private lazy var webAddressDetail:UILabel = {
        let label = UILabel.init()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.blue
        label.lineBreakMode = .byCharWrapping
        label.backgroundColor = UIColor.clear
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(jump))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    private lazy var line:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
  
   dynamic var comp:CompanyDetail?{
        didSet{
            adressDetail.text = comp?.address
            webAddressDetail.text = comp?.webSite
            self.setupAutoHeight(withBottomView: webAddress, bottomMargin: 10)
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let views:[UIView] = [title, address, adressDetail,webAddress, webAddressDetail,line]
        self.contentView.sd_addSubviews(views)
        _ = title.sd_layout().leftSpaceToView(self.contentView,20)?.topSpaceToView(self.contentView,5)?.autoHeightRatio(0)
        _ = line.sd_layout().topSpaceToView(title,5)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.heightIs(1)
        _ = address.sd_layout().leftEqualToView(title)?.topSpaceToView(line,5)?.autoHeightRatio(0)
        _ = adressDetail.sd_layout().leftSpaceToView(address,5)?.topEqualToView(address)?.autoHeightRatio(0)
        _ = webAddress.sd_layout().topSpaceToView(address,5)?.leftEqualToView(address)?.autoHeightRatio(0)
        _ = webAddressDetail.sd_layout().leftEqualToView(adressDetail)?.topEqualToView(webAddress)?.autoHeightRatio(0)
        
        adressDetail.setMaxNumberOfLinesToShow(2)
        webAddressDetail.setMaxNumberOfLinesToShow(2)
        
        
        //self.contentView.addSubview(line)
        //_ = line.sd_layout().leftEqualToView(label)?.rightEqualToView(self.contentView)?.topSpaceToView(label,5)?.heightIs(1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


extension CompanyDetailCell{
    private func handler(bool:Bool){
        
    }
    @objc private func jump(){
        
        if let url = webAddressDetail.text{
            
            openApp(appURL: url, completion: handler)
        }
        
    }
}
