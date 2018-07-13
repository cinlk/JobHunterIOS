//
//  resume_personInfoCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let fontSize:CGFloat = 14
fileprivate let textColort:UIColor = UIColor.black
fileprivate let leftAlignment = NSTextAlignment.left
fileprivate let imgSize:CGSize = CGSize.init(width: 60, height: 60)


@objcMembers class resume_personInfoCell: UITableViewCell {

  
    private var touxaing:UIImageView = {
        let tx = UIImageView.init(frame: CGRect.zero)
        tx.contentMode = .scaleToFill
        tx.clipsToBounds = true 
        return tx
    }()
    
    private var name:UILabel = {
        let name = UILabel.init()
        name.font = UIFont.boldSystemFont(ofSize: 14)
        name.textColor = textColort
        name.textAlignment = .center
        name.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return name
    }()
    
    private var sex:UILabel = {
        let sex = UILabel.init()
        sex.font = UIFont.systemFont(ofSize: fontSize)
        sex.textColor = textColort
        sex.textAlignment = leftAlignment
        sex.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return sex
    }()
    
    private var city:UILabel = {
        let city = UILabel.init()
        city.font = UIFont.systemFont(ofSize: fontSize)
        city.textColor = textColort
        city.textAlignment = leftAlignment
        city.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return city
    }()
    
    private var degree:UILabel = {
        let degree = UILabel.init()
        degree.font = UIFont.systemFont(ofSize: fontSize)
        degree.textColor = textColort
        degree.textAlignment = leftAlignment
        degree.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return degree
    }()
    
    private var birthday:UILabel = {
        let birthday = UILabel.init()
        birthday.font = UIFont.systemFont(ofSize: fontSize)
        birthday.textColor = textColort
        birthday.textAlignment = leftAlignment
        birthday.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return birthday
    }()
    
    private var phone:UILabel = {
        let phone = UILabel.init()
        phone.font = UIFont.systemFont(ofSize: fontSize)
        phone.textColor = textColort
        phone.textAlignment = leftAlignment
        phone.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return phone
    }()
    
    private var email:UILabel = {
        let email = UILabel.init()
        email.font = UIFont.systemFont(ofSize: fontSize)
        email.textColor = textColort
        email.textAlignment = leftAlignment
        email.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return email
    }()
    
    // combine lables
    private var lable1:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = textColort
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        return label
    }()
    
    private var lable2:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = textColort
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
    
        return label
    }()
    
    
    dynamic var mode:personalBasicalInfo?{
        
        didSet{
            
            guard let mode = mode else { return }
            
            touxaing.image = UIImage.init(named:  mode.tx)
            
            
            name.text = mode.name
            sex.text = mode.gender
            city.text = mode.city
            phone.text = mode.phone
            degree.text = mode.degree
            
            birthday.text = mode.birthday
            email.text = mode.email
            
            lable1.text = mode.gender! + "|" + mode.city + "|" + mode.degree! + "|" + mode.birthday!
            lable2.text = mode.phone! + "|" + mode.email!
            
            // cell 自适应高度
            self.setupAutoHeight(withBottomViewsArray: [touxaing,lable1,lable2], bottomMargin: 10)
           
        }
    }
    
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let views:[UIView] = [touxaing, name, lable1, lable2]
        self.contentView.sd_addSubviews(views)
        
       
        _ = touxaing.sd_layout().centerXEqualToView(self.contentView)?.topSpaceToView(self.contentView,20)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
        
        
        _ = name.sd_layout().centerXEqualToView(self.contentView)?.topSpaceToView(touxaing,5)?.autoHeightRatio(0)
        
        _ = lable1.sd_layout().centerXEqualToView(self.contentView)?.topSpaceToView(name,5)?.autoHeightRatio(0)
        _ = lable2.sd_layout().centerXEqualToView(self.contentView)?.topSpaceToView(lable1,5)?.autoHeightRatio(0)
        // 布局之后设置
        self.lable1.setMaxNumberOfLinesToShow(1)
        self.lable2.setMaxNumberOfLinesToShow(1)
        touxaing.sd_cornerRadiusFromWidthRatio = 0.5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "resume_personInfoCell"
    }
    
    
    
}
