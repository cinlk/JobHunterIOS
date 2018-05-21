//
//  resumePersonInfoCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/3.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class resumePersonInfoCell: UITableViewCell {
    
    private lazy var gender:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "性别:    "
        return label
    }()
    
    private lazy var degree:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "最高学位: "
        return label
    }()
    private lazy var city:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "所在城市: "
        return label
    }()
    private lazy var birthday:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "出生年份: "
        return label
    }()
    private lazy var phone:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "联系电话: "
        return label
    }()
    private lazy var email:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "联系邮箱: "
        return label
    }()
     // 对应值
    private lazy var genderDes:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var degreeDes:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private lazy var cityDes:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
   
    private lazy var phoneDes:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private lazy var birthdayDes:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private lazy var emailDes:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 80)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
   dynamic var mode:personalBasicalInfo?{
        didSet{
            guard let mode = mode else { return }
            self.genderDes.text =  mode.gender
            self.degreeDes.text = mode.degree
            self.cityDes.text = mode.city
            self.birthdayDes.text = mode.birthday
            self.phoneDes.text = mode.phone
            self.emailDes.text = mode.email
            
            
            self.setupAutoHeight(withBottomView: email, bottomMargin: 10)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views:[UIView] = [gender,genderDes,city,cityDes, degree, degreeDes, birthday, birthdayDes, phone, phoneDes,
                              email, emailDes]
        
        self.contentView.sd_addSubviews(views)
        
        _ = gender.sd_layout().topSpaceToView(self.contentView,10)?.leftSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        _ = genderDes.sd_layout().leftSpaceToView(gender,5)?.topEqualToView(gender)?.autoHeightRatio(0)
        _ = degree.sd_layout().topSpaceToView(gender,10)?.leftEqualToView(gender)?.autoHeightRatio(0)
        _ = degreeDes.sd_layout().topEqualToView(degree)?.leftSpaceToView(degree,5)?.autoHeightRatio(0)
        _ = city.sd_layout().topSpaceToView(degree,10)?.leftEqualToView(degree)?.autoHeightRatio(0)
        _ = cityDes.sd_layout().topEqualToView(city)?.leftSpaceToView(city,5)?.autoHeightRatio(0)
        _ = birthday.sd_layout().topSpaceToView(city,10)?.leftEqualToView(city)?.autoHeightRatio(0)
        _ = birthdayDes.sd_layout().topEqualToView(birthday)?.leftSpaceToView(birthday,5)?.autoHeightRatio(0)
        _ = phone.sd_layout().topSpaceToView(birthday,10)?.leftEqualToView(birthday)?.autoHeightRatio(0)
        _ = phoneDes.sd_layout().topEqualToView(phone)?.leftSpaceToView(phone,5)?.autoHeightRatio(0)
        _ = email.sd_layout().topSpaceToView(phone,10)?.leftEqualToView(phone)?.autoHeightRatio(0)
        _ = emailDes.sd_layout().leftSpaceToView(email,5)?.topEqualToView(email)?.autoHeightRatio(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "resumePersonInfoCell"
    }
    

}
