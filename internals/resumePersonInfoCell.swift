//
//  resumePersonInfoCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/3.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let prexGender:String = "性别:    "
fileprivate let preDegree:String =  "最高学位: "
fileprivate let preCity:String =    "所在城市: "
fileprivate let preBirthday:String = "出生年份: "
fileprivate let prePhone:String =   "联系电话: "
fileprivate let preEmail:String =   "联系邮箱: "


@objcMembers class resumePersonInfoCell: UITableViewCell {
    
    private lazy var gender:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var degree:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private lazy var city:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private lazy var birthday:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private lazy var phone:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private lazy var email:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    
    
   dynamic var mode:personalBasicalInfo?{
        didSet{
            guard let mode = mode else { return }
            self.gender.text = prexGender +  mode.gender
            self.degree.text = preDegree + mode.degree
            self.city.text = preCity + mode.city
            self.birthday.text = preBirthday + mode.birthday
            self.phone.text = prePhone + mode.phone
            self.email.text =  preEmail + mode.email
            
            
            self.setupAutoHeight(withBottomView: email, bottomMargin: 10)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [gender,city, degree, birthday, phone, email]
        
        self.contentView.sd_addSubviews(views)
        
        _ = gender.sd_layout().topSpaceToView(self.contentView,10)?.leftSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = degree.sd_layout().topSpaceToView(gender,10)?.leftEqualToView(gender)?.autoHeightRatio(0)
        _ = city.sd_layout().topSpaceToView(degree,10)?.leftEqualToView(degree)?.autoHeightRatio(0)
        _ = birthday.sd_layout().topSpaceToView(city,10)?.leftEqualToView(city)?.autoHeightRatio(0)
        _ = phone.sd_layout().topSpaceToView(birthday,10)?.leftEqualToView(birthday)?.autoHeightRatio(0)
        _ = email.sd_layout().topSpaceToView(phone,10)?.leftEqualToView(phone)?.autoHeightRatio(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "resumePersonInfoCell"
    }
    

}
