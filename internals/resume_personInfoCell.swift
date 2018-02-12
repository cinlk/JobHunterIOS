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
fileprivate let cellH:CGFloat = 150.0

class resume_personInfoCell: UITableViewCell {

  
    private var touxaing:UIImageView = {
        let tx = UIImageView.init()
        tx.contentMode = .scaleToFill
        return tx
    }()
    
    private var name:UILabel = {
        let name = UILabel.init()
        name.font = UIFont.boldSystemFont(ofSize: 14)
        name.textColor = textColort
        name.textAlignment = .center
        return name
    }()
    
    private var sex:UILabel = {
        let sex = UILabel.init()
        sex.font = UIFont.systemFont(ofSize: fontSize)
        sex.textColor = textColort
        sex.textAlignment = leftAlignment
        return sex
    }()
    
    private var city:UILabel = {
        let city = UILabel.init()
        city.font = UIFont.systemFont(ofSize: fontSize)
        city.textColor = textColort
        city.textAlignment = leftAlignment
        return city
    }()
    
    private var degree:UILabel = {
        let degree = UILabel.init()
        degree.font = UIFont.systemFont(ofSize: fontSize)
        degree.textColor = textColort
        degree.textAlignment = leftAlignment
        return degree
    }()
    
    private var birthday:UILabel = {
        let birthday = UILabel.init()
        birthday.font = UIFont.systemFont(ofSize: fontSize)
        birthday.textColor = textColort
        birthday.textAlignment = leftAlignment
        return birthday
    }()
    
    private var phone:UILabel = {
        let phone = UILabel.init()
        phone.font = UIFont.systemFont(ofSize: fontSize)
        phone.textColor = textColort
        phone.textAlignment = leftAlignment
        return phone
    }()
    
    private var email:UILabel = {
        let email = UILabel.init()
        email.font = UIFont.systemFont(ofSize: fontSize)
        email.textColor = textColort
        email.textAlignment = leftAlignment
        return email
    }()
    
    // combine lables
    private var lable1:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = textColort
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        return label
    }()
    
    private var lable2:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = textColort
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        return label
    }()
    
    
    var mode:person_base_info?{
        
        didSet{
            self.touxaing.image = UIImage.init(named:  mode!.tx)
            name.text = mode!.name
            sex.text = mode!.sex
            city.text = mode!.city
            phone.text = mode!.phone
            degree.text = mode!.degree
            birthday.text = mode!.birthday
            email.text = mode!.email
            lable1.text = mode!.sex + "|" + mode!.city + "|" + mode!.degree + "|" + mode!.birthday
            lable2.text = mode!.phone + "|" + mode!.email
        }
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
        self.contentView.addSubview(touxaing)
        self.contentView.addSubview(name)
        self.contentView.addSubview(lable1)
        self.contentView.addSubview(lable2)
        name.sizeToFit()
        lable1.sizeToFit()
        lable2.sizeToFit()
        
        
        _ = touxaing.sd_layout().centerXEqualToView(self.contentView)?.topSpaceToView(self.contentView,10)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
        _ = name.sd_layout().centerXEqualToView(self.contentView)?.topSpaceToView(touxaing,5)?.widthIs(200)?.heightIs(20)
        
        _ = lable1.sd_layout().centerXEqualToView(self.contentView)?.topSpaceToView(name,5)?.widthIs(ScreenW - 20)?.heightIs(20)
        _ = lable2.sd_layout().centerXEqualToView(self.contentView)?.topSpaceToView(lable1,5)?.widthIs(ScreenW - 20)?.heightIs(20)
        
        touxaing.setCircle()
        
        
    }
    
    class func identity()->String{
        return "resume_personInfoCell"
    }
    
    class func cellHeight()->CGFloat{
        return cellH
    }
    
    
}
